class Favorite < ApplicationRecord
  belongs_to :user
  belongs_to :post
  validates :cannot_favorite_self_recipe
  validates :user_id, uniqueness: {
    scope: :recipe_id,
    message: "既にお気に入り登録されています。"
  }

  private

  def cannot_favorite_self_recipe
    errors.add(:base, "自分のレシピにお気に入りをすることはできません") if user_id == post.user_id
  end
end
