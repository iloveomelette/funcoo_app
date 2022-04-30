class UsersController < ApplicationController
  def show
    @post_recipes = Recipe.where(user_id: current_user.id).order(created_at: :desc).page(params[:page]).per(PER_PAGE)
    @maked_recipes = Recipe.where(id: current_user.maked_recipes.pluck(:recipe_id)).page(params[:page]).per(PER_PAGE)
  end
end
