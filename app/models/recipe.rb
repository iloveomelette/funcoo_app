class Recipe < ApplicationRecord
  belongs_to :user
  has_many :makes, dependent: :destroy
  has_many :maked_users, through: :makes, source: :user

  validates :title, presence: true, length: { maximum: 100 }
  validates :content, presence: true, length: { maximum: 500 }
  validates :cooking_time, length: { in: 0..200 }
  validates :cooking_cost, length: { in: 0..10_000 }
  validates :calorie, length: { in: 0..3000 }

  # CarrierWaveとmenu_imageカラム、profile_imageカラムの連携
  mount_uploader :menu_image, MenuImageUploader

  # 「作ってみた!」を押しているかどうか判定するメソッド
  def maked_by?(user)
    makes.any? { |make| make.user_id == user.id }
  end

  def self.recommend(user)
    base_recipes = Make.where(user_id: user.id).order(created_at: :desc)
    base_recipe = Recipe.find_by(id: base_recipes[5].recipe_id)
    relation_users = base_recipe.maked_users.ids
    relation_users_maked = Make.where(user_id: relation_users[0]).order(recipe_id: :desc)
    Recipe.find_by(id: relation_users_maked[0].recipe_id)
  end
end
