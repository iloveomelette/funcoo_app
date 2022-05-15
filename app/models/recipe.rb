class Recipe < ApplicationRecord
  belongs_to :user
  has_many :makes, dependent: :destroy
  has_many :maked_users, through: :makes, source: :user
  has_many :favorites, dependent: :destroy
  has_many :favorited_users, through: :favorites, source: :user
  has_one :genre, dependent: :destroy

  validates :title, presence: true, length: { maximum: 100 }
  validates :content, presence: true, length: { maximum: 2000 }
  validates :cooking_time, length: { in: 0..200 }
  validates :cooking_cost, length: { in: 0..10_000 }
  validates :calorie, length: { in: 0..3000 }

  # CarrierWaveとmenu_imageカラム、profile_imageカラムの連携
  mount_uploader :menu_image, MenuImageUploader

  # 「作ってみた!」を押しているかどうか判定するメソッド
  def maked_by?(user)
    makes.any? { |make| make.user_id == user.id }
  end

  # お気に入りを押しているかどうか判定するメソッド
  def favorited_by?(user)
    favorites.any? { |favorite| favorite.user_id == user.id }
  end

  class << self
    # ===== レコメンドレシピを渡す処理 =====
    def recommend_recipe(recommend_recipe_id, current_user)
      if current_user.characteristic == "general"
        Recipe.find_by(id: recommend_recipe_id)
      elsif current_user.email == "guest@example.com"
        Recipe.find_by(id: Recipe.order(created_at: :desc).limit(1).pluck(:id))
      end
    end
  end
end
