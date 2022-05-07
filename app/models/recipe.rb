class Recipe < ApplicationRecord
  belongs_to :user
  has_many :makes, dependent: :destroy
  has_many :maked_users, through: :makes, source: :user
  has_many :favorites, dependent: :destroy
  has_many :favorited_users, through: :favorites, source: :user
  has_one :genre, dependent: :destroy

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

  # お気に入りを押しているかどうか判定するメソッド
  def favorited_by?(user)
    favorites.any? { |favorite| favorite.user_id == user.id }
  end

  class << self
    # レコメンド機能
    def recommend(user)
      # ログインユーザが「作ってみた！」を押した全ての投稿を新着順に取得
      base_recipes = Make.where(user_id: user.id).order(created_at: :desc)
      # その投稿の中で5番目のものを取得
      base_recipe = base_recipes[4]
      return nil if base_recipe.nil?

      other = Recipe.take_user(base_recipe)
      Recipe.take_recipe(other)
    end

    def take_user(base_recipe)
      # その投稿に「作ってみた！」を押した全ての他ユーザを取得
      others = Make.where(recipe_id: base_recipe.recipe_id).order(created_at: :desc)
      # その投稿の中で最後に押した他ユーザを返す
      others.first
    end

    def take_recipe(other)
      # そのユーザが「作ってみた！」を押した全ての投稿を取得
      other_maked_recipes = Make.where(user_id: other.user_id).order(created_at: :desc)
      # その投稿の中で最新の投稿を取得する
      other_maked_recipe = other_maked_recipes.first
      # レシピクラスで投稿を取得する
      Recipe.find_by(id: other_maked_recipe.recipe_id)
    end
  end
end
