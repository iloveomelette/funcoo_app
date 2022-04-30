class UsersController < ApplicationController
  def show
    @recipes = if current_user.characteristic == "general"
                 Recipe.where(id: current_user.maked_recipes.pluck(:recipe_id)).page(params[:page]).per(PER_PAGE)
               else
                 Recipe.where(user_id: current_user.id).order(created_at: :desc).page(params[:page]).per(PER_PAGE)
               end
  end
end
