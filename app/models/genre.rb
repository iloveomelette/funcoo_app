class Genre < ApplicationRecord
  belongs_to :recipe
  validates :staple_food, :main_dish, :side_dish, :country_dish, presence: true

  # 主食カラム
  enum staple_food: {
    others: 0,
    rice: 1,
    bread: 2,
    noodles: 3
  }, _prefix: true
  # 主菜カラム
  enum main_dish: {
    others: 0,
    meat: 1,
    fish: 2,
    egg: 3,
    soybean: 4
  }, _prefix: true
  # 副菜カラム
  enum side_dish: {
    others: 0,
    vegetables: 1,
    mushroom: 2,
    potato: 3
  }, _prefix: true
  # 各国料理カラム
  enum country_dish: {
    others: 0,
    japanese: 1,
    korean: 2,
    chinese: 3,
    italian: 4,
    asian: 5,
    ethnic: 6
  }, _prefix: true
end
