class LevelSetting < ApplicationRecord
  def self.calc_adding_point(user)
    adding_point = if user.experience_point.zero?
                     15
                   else
                     user.experience_point * 0.2
                   end
    adding_point.round
  end
end
