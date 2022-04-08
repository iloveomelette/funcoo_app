class MakeRecipeForm
  include ActiveModel::Model
  extend CarrierWave::Mount

  attr_accessor :title, :content, :menu_image, :cooking_time, :cooking_cost, :calorie, :user_id

  validates :title, presence: true, length: { maximum: 100 }
  validates :content, presence: true, length: { maximum: 500 }
  validates :cooking_time, length: { in: 0..200 }
  validates :cooking_cost, length: { in: 0..10_000 }
  validates :calorie, length: { in: 0..3000 }

  mount_uploader :menu_image, MenuImageUploader

  def save
    Recipe.create(user_id:, title:, content:, menu_image:, cooking_time:, cooking_cost:, calorie:)
  end
end
