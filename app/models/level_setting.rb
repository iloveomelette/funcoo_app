class LevelSetting < ApplicationRecord
  class << self
    def calc_level(user)
      current_point = user.experience_point
      adding_point = calc_adding_point(user)
      update_experience_point(user, current_point, adding_point)
      update_level(user)
    end

    def calc_adding_point(user)
      adding_point = user.experience_point * 0.2
      adding_point.round
    end

    def update_experience_point(current_user, current_point, adding_point)
      current_point += adding_point
      current_user.update!(experience_point: current_point)
    end

    def update_level(current_user)
      next_level = LevelSetting.find_by(passing_level: current_user.level + 1)
      return unless next_level.threshold <= current_user.experience_point

      current_user.level += 1
      current_user.update!(level: current_user.level)
    end
  end
  private_class_method :calc_adding_point,
                       :update_experience_point,
                       :update_level
end
