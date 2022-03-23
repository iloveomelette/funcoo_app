class User < ApplicationRecord
  has_many :recipes, dependent: :destroy

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
end
