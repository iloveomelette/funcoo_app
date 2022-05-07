class Favorite < ApplicationRecord
  belongs_to :user
  belongs_to :recipe
  validate :cannot_favorite_self_recipe
  validates :user_id, uniqueness: {
    scope: :recipe_id,
    message: "すでにお気に入りされています"
  }

  private

  def cannot_favorite_self_recipe
    errors.add(:base, "自分のレシピはお気に入りできません") if user_id == recipe.user_id
  end
end
