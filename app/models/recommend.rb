class Recommend < ApplicationRecord
  belongs_to :user
  validates :recommend_recipe, :avg_staple, :avg_main, :avg_side, :avg_country, presence: true
end
