class Genre < ApplicationRecord
  belongs_to :recipe
  validates :staple_food, :main_dish, :side_dish, presence: true
end
