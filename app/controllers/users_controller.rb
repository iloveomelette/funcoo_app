class UsersController < ApplicationController
  def show
    @recipes = take_user_recipes
    recipe_ids = Favorite.includes(:user).where(user_id: current_user.id).order(created_at: :desc).pluck(:recipe_id)
    @favorite_recipes = Recipe.where(id: recipe_ids).page(params[:page]).per(PER_PAGE)
  end

  private

  def take_user_recipes
    if current_user.characteristic == "general"
      Recipe.includes(:user, :makes, :favorites).where(id: current_user.maked_recipes.pluck(:recipe_id)).page(params[:page]).per(PER_PAGE)
    else
      Recipe.includes(:user, :makes, :favorites).where(user_id: current_user.id).order(created_at: :desc).page(params[:page]).per(PER_PAGE)
    end
  end
end
