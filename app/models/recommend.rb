class Recommend < ApplicationRecord
  belongs_to :user
  with_options presence: true do
    validates :recommend_recipe
    validates :avg_staple
    validates :avg_main
    validates :avg_side
    validates :avg_country
    validates :sum_staple
    validates :sum_main
    validates :sum_side
    validates :sum_country
  end
end
