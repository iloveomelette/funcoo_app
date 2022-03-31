class Make < ApplicationRecord
  # 自分の投稿に「作ってみた!」をできないように制限
  validate :cannot_make_selfrecipe

  belongs_to :user
  belongs_to :recipe

  validates :user_id, uniqueness: {
    scope: :recipe_id,
    message: "は同じ投稿に2回以上できません"
  }

  private

  def cannot_make_selfrecipe
    errors.add(:base, "自分のレシピに「作ってみた!」はできません") if user_id == recipe.user_id
  end
end
