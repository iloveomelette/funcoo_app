class UsersController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  def show
    if params[:page] == "mypage"
      @recipes = if current_user.characteristic == "general"
                   take_stored_recipe(current_user.maked_recipe_ids)
                 else
                   take_contributed_recipes(current_user.id)
                 end
      @favorite_recipes = take_stored_recipe(current_user.favorited_recipe_ids)
    else
      @contributor = User.find(params[:id])
      @contributor_recipes = take_contributed_recipes(@contributor.id)
    end
  end

  private

  def take_stored_recipe(recipe_ids)
    Recipe.includes(:user, :makes, :favorites).where(id: recipe_ids).order(created_at: :desc).page(params[:page]).per(PER_PAGE)
  end

  def take_contributed_recipes(user_id)
    Recipe.includes(:user, :makes, :favorites).where(user_id:).order(created_at: :desc).page(params[:page]).per(PER_PAGE)
  end

  def record_not_found
    redirect_to recipes_path
  end
end
