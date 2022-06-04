class LevelSetting < ApplicationRecord
  FIRST_ADDING_POINT = 15
  ADDING_POINT_RATE = 0.2

  class << self
    def calc_level(user)
      current_point, adding_point = calc_adding_point(user)    # ===== 現在の経験値と加算する経験値を計算する処理 =====
      experience_point, next_level, rest_point = calc_related_level(current_point, adding_point, user) # ===== レベル関連を計算する処理 =====
      user.update!(level: next_level, experience_point:, rest_point:)
    end

    # ===== ここからclass_privateメソッド =====
    def calc_adding_point(user)
      current_point = user.experience_point
      adding_point = current_point.zero? ? FIRST_ADDING_POINT : user.experience_point * ADDING_POINT_RATE
      [current_point, adding_point.round]
    end

    def calc_related_level(current_point, adding_point, user)
      current_point += adding_point
      next_level = define_next_level(user.level)
      if next_level.threshold <= current_point
        user.level += 1
        next_level = define_next_level(user.level)
      end
      rest_point = next_level.threshold - current_point
      [current_point, user.level, rest_point]
    end

    def define_next_level(user_level)
      LevelSetting.find_by(passing_level: user_level + 1)
    end
  end
  private_class_method :calc_adding_point, :calc_related_level, :define_next_level
end
