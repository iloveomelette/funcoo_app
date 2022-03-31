class Recipe < ApplicationRecord
  belongs_to :user
  has_many :makes, dependent: :destroy
  has_many :maked_users, through: :makes, source: :user

  validates :title, presence: true, length: { maximum: 100 }
  validates :content, presence: true, length: { maximum: 500 }
  validates :cooking_time, length: { in: 0..200 }
  validates :cooking_cost, length: { in: 0..10_000 }
  validates :calorie, length: { in: 0..3000 }

  # 「作ってみた!」を押しているかどうか判定するメソッド
  def maked_by?(user)
    makes.any? { |make| make.user_id == user.id }
  end

  # CarrierWaveとmenu_imageカラム、profile_imageカラムの連携
  mount_uploader :menu_image, MenuImageUploader
end
