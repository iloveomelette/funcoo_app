class User < ApplicationRecord
  has_many :recipes, dependent: :destroy
  has_many :makes, dependent: :destroy
  has_many :maked_recipes, through: :makes, source: :recipe
  has_many :sns_credential, dependent: :destroy

  with_options presence: true do
    validates :name, length: { maximum: 50 }
    validates :email, length: { maximum: 255 }
    validates :characteristic
    validates :level
    validates :experience_point
    validates :rest_point
  end
  validates :introduction, length: { maximum: 200 }
  # 法人または一般の属性を定義
  enum characteristic: {
    general: 0,
    corporation: 1
  }
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         # Omniauthを使用するためのオプション
         :omniauthable, omniauth_providers: %i[google_oauth2]

  # 画像投稿のためのアップローダをprofile_imageと連携
  mount_uploader :profile_image, ProfileImageUploader

  class << self
    def guest
      find_or_create_by!(email: "guest@example.com") do |user|
        user.password = SecureRandom.urlsafe_base64
        user.name = "ゲストユーザ"
        user.characteristic = 1
      end
    end

    # ここからOmniauth関連のメソッド
    def without_sns_data(auth)
      user = User.where(email: auth.info.email).first

      if user.present?
        sns = SnsCredential.create(
          uid: auth.uid,
          provider: auth.provider,
          user_id: user.id
        )
      else
        user = User.create(
          name: auth.info.name,
          email: auth.info.email,
          profile_image: auth.info.image,
          password: Devise.friendly_token(10)
        )
        sns = SnsCredential.create(
          user_id: user.id,
          uid: auth.uid,
          provider: auth.provider
        )
      end
      { user:, sns: }
    end

    def with_sns_data(auth, snscredential)
      user = User.where(id: snscredential.user_id).first
      if user.blank?
        user = User.new(
          name: auth.info.name,
          email: auth.info.email
        )
      end
      { user: }
    end

    def find_oauth(auth)
      uid = auth.uid
      provider = auth.provider
      snscredential = SnsCredential.where(uid:, provider:).first
      if snscredential.present?
        user = with_sns_data(auth, snscredential)[:user]
        sns = snscredential
      else
        user = without_sns_data(auth)[:user]
        sns = without_sns_data(auth)[:sns]
      end
      { user:, sns: }
    end
  end
end
