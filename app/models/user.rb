class User < ApplicationRecord
  has_many :recipes, dependent: :destroy
  has_many :makes, dependent: :destroy
  has_many :maked_recipes, through: :makes, source: :recipe

  validates :name, presence: true, length: { maximum: 50 }
  validates :email, presence: true, length: { maximum: 255 }
  validates :introduction, length: { maximum: 200 }
  validates :characteristic, presence: true
  # 法人または一般の属性を定義
  enum characteristic: {
    general: 0,
    corporation: 1
  }
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  def self.guest
    find_or_create_by!(email: "guest@example.com") do |user|
      user.password = SecureRandom.urlsafe_base64
      user.name = "ゲストユーザ"
      user.characteristic = 1
    end
  end

  # 画像投稿のためのアップローダをprofile_imageと連携
  mount_uploader :profile_image, ProfileImageUploader
end
