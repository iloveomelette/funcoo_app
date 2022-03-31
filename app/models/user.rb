class User < ApplicationRecord
  has_many :recipes, dependent: :destroy
  has_many :makes, dependent: :destroy

  validates :name, presence: true
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
    end
  end

  # 画像投稿のためのアップローダをprofile_imageと連携
  mount_uploader :profile_image, ProfileImageUploader
end
