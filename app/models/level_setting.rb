class LevelSetting < ApplicationRecord
  class << self
    def calc_level(user)
      current_point = user.experience_point
      adding_point = calc_adding_point(user)
      update_experience_point(user, current_point, adding_point)
      update_level(user)
      calc_rest_point(user)
    end

    # ===== ここからclass_privateメソッド =====
    def calc_adding_point(user)
      adding_point = if user.experience_point.zero?
                       15
                     else
                       user.experience_point * 0.2
                     end
      adding_point.round
    end

    def update_experience_point(current_user, current_point, adding_point)
      current_point += adding_point
      current_user.update!(experience_point: current_point)
    end

    def update_level(current_user)
      next_level = define_next_level(current_user)
      return unless next_level.threshold <= current_user.experience_point

      current_user.level += 1
      current_user.update!(level: current_user.level)
      next_level
    end

    def calc_rest_point(user)
      next_level = define_next_level(user)
      rest_point = next_level.threshold - user.experience_point
      user.update!(rest_point:)
    end

    def define_next_level(user)
      LevelSetting.find_by(passing_level: user.level + 1)
    end
  end
  private_class_method :calc_adding_point,
                       :update_experience_point,
                       :update_level,
                       :define_next_level,
                       :calc_rest_point
end
