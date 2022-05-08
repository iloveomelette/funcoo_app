class UsersController < ApplicationController
  def show
    @recipes = if current_user.characteristic == "general"
                 Recipe.includes(:user, :makes, :favorites).where(id: current_user.maked_recipes.pluck(:recipe_id)).page(params[:page]).per(PER_PAGE)
               else
                 Recipe.includes(:user, :makes, :favorites).where(user_id: current_user.id).order(created_at: :desc).page(params[:page]).per(PER_PAGE)
               end
    recipe_ids = Favorite.includes(:user).where(user_id: current_user.id).order(created_at: :desc).pluck(:recipe_id)
    @favorite_recipes = Recipe.find(recipe_ids)
  end
end
