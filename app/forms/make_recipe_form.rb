class MakeRecipeForm
  include ActiveModel::Model
  extend CarrierWave::Mount

  attr_accessor :title, :content, :menu_image, :cooking_time,
                :cooking_cost, :calorie, :user_id, :staple_food,
                :main_dish, :side_dish, :country_dish

  validates :title, presence: true, length: { maximum: 100 }
  validates :content, presence: true, length: { maximum: 500 }
  validates :cooking_time, length: { in: 0..200 }
  validates :cooking_cost, length: { in: 0..10_000 }
  validates :calorie, length: { in: 0..3000 }
  validates :staple_food, :main_dish, :side_dish, :country_dish, presence: true

  mount_uploader :menu_image, MenuImageUploader

  delegate :persisted?, to: :recipe

  def initialize(attributes = nil, recipe: Recipe.new, genre: Genre.new)
    @recipe = recipe
    @genre = genre
    attributes ||= default_attributes
    super(attributes)
  end

  def save
    ActiveRecord::Base.transaction do
      recipe = Recipe.create(user_id:, title:, content:, menu_image:, cooking_time:, cooking_cost:, calorie:)
      Genre.create(recipe_id: recipe.id, staple_food:, main_dish:, side_dish:, country_dish:)
    end
  rescue ActiveRecord::RecordInvalid
    false
  end

  def update_recipe
    ActiveRecord::Base.transaction do
      recipe.update(user_id:, title:, content:, menu_image:, cooking_time:, cooking_cost:, calorie:)
      Genre.update(recipe_id: recipe.id, staple_food:, main_dish:, side_dish:, country_dish:)
    end
  rescue ActiveRecord::RecordInvalid
    false
  end

  private

  attr_reader :recipe, :genre

  def default_attributes
    {
      user_id: recipe.user_id,
      title: recipe.title,
      content: recipe.content,
      menu_image: recipe.menu_image,
      cooking_time: recipe.cooking_time,
      cooking_cost: recipe.cooking_cost,
      calorie: recipe.calorie,
      staple_food: genre.staple_food,
      main_dish: genre.main_dish,
      side_dish: genre.side_dish,
      country_dish: genre.country_dish
    }
  end
end
