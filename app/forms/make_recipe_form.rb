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

  delegate :persisted?, to: :recipe

  def initialize(attributes = nil, recipe: Recipe.new)
    @recipe = recipe
    attributes ||= default_attributes
    super(attributes)
  end

  def save
    Recipe.create(user_id:, title:, content:, menu_image:, cooking_time:, cooking_cost:, calorie:)
  end

  def update_recipe
    ActiveRecord::Base.transaction do
      recipe.update!(user_id:, title:, content:, menu_image:, cooking_time:, cooking_cost:, calorie:)
    end
  rescue ActiveRecord::RecordInvalid
    false
  end

  def to_model
    recipe
  end

  private

  attr_reader :recipe

  def default_attributes
    {
      user_id: recipe.user_id,
      title: recipe.title,
      content: recipe.content,
      menu_image: recipe.menu_image,
      cooking_time: recipe.cooking_time,
      cooking_cost: recipe.cooking_cost,
      calorie: recipe.calorie
    }
  end
end
