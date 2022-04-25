class LevelSetting < ApplicationRecord
  class << self
    def calc_level(user)
      current_point = user.experience_point
      adding_point = calc_adding_point(user)
      update_experience_point(user, current_point, adding_point)
      update_level(user)
      calc_rest_point(user)
    end

    def down_level(user)
      current_point = user.experience_point
      reducing_point = calc_reducing_point(current_point)
      reducing_current_point(user, current_point, reducing_point)
      down_current_level(user)
      calc_rest_point(user)
    end

    # *-*-* ここからclass_privateメソッド *-*-*
    # *-*-* ここからcalc_levelメソッドの呼び出し先 *-*-*
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

    # *-*-* ここからdown_levelメソッドの呼び出し先 *-*-*
    def calc_reducing_point(current_point)
      reducing_point = current_point * 0.2
      reducing_point.round
    end

    def reducing_current_point(current_user, current_point, reducing_point)
      current_point -= reducing_point
      current_user.update!(experience_point: current_point)
    end

    def down_current_level(current_user)
      current_level = LevelSetting.find_by(passing_level: current_user.level)
      return unless current_level.present? && current_level.threshold >= current_user.experience_point

      current_user.level -= 1
      current_user.update!(level: current_user.level)
    end

    # *-*-* ここからdown_level、calc_levelメソッド共通の呼び出し先 *-*-*
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
                       :calc_reducing_point,
                       :reducing_current_point,
                       :down_current_level,
                       :define_next_level,
                       :calc_rest_point
end
