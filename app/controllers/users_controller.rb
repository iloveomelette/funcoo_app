class UsersController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  def show
    @contributor = User.find(params[:id])
    @contributor_recipes = take_contributor_recipes(@contributor.id)
  end

  def mypage
    @recipes = contributed_or_maked_recipes
    @favorite_recipes = Recipe.includes(:user, :makes,
                                        :favorites).where(id: current_user.favorited_recipe_ids).order(created_at: :desc).page(params[:page]).per(PER_PAGE)
  end

  private

  def contributed_or_maked_recipes
    if current_user.characteristic == "general"
      Recipe.includes(:user, :makes, :favorites).where(id: current_user.maked_recipe_ids).page(params[:page]).per(PER_PAGE)
    else
      take_contributor_recipes(current_user.id)
    end
  end

  def take_contributor_recipes(user_id)
    Recipe.includes(:user, :makes, :favorites).where(user_id:).order(created_at: :desc).page(params[:page]).per(PER_PAGE)
  end

  def record_not_found
    redirect_to recipes_path
  end
end
