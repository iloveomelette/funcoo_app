class RecipesController < ApplicationController
  def index
    @recipes = Recipe.includes(:user).order(created_at: :desc)
  end

  def new
    @recipe = Recipe.new
  end

  def create
    @recipe = current_user.recipes.new(recipe_params)
    if @recipe.save
      redirect_to @recipe, notice: "投稿しました!"
    else
      render :new
    end
  end

  def show; end

  def edit; end

  def update; end

  def destroy; end

  private

  def recipe_params
    params.require(:recipe).permit(:title, :content, :menu_image, :cooking_time, :cooking_cost, :calorie)
  end
end
