class UsersController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  def show
    if params[:page] == "mypage"
      @recipes = if current_user.characteristic == "general"
                   Recipe.includes(:user, :makes,
                                   :favorites).where(id: current_user.maked_recipe_ids).order(created_at: :desc).page(params[:page]).per(PER_PAGE)
                 else
                   Recipe.includes(:user, :makes, :favorites).where(user_id: current_user.id).order(created_at: :desc).page(params[:page]).per(PER_PAGE)
                 end
      @favorite_recipes = Recipe.includes(:user, :makes,
                                          :favorites).where(id: current_user.favorited_recipe_ids).order(created_at: :desc).page(params[:page]).per(PER_PAGE)
    else
      @contributor = User.find(params[:id])
      @contributor_recipes = Recipe.includes(:user, :makes,
                                             :favorites).where(user_id: @contributor.id).order(created_at: :desc).page(params[:page]).per(PER_PAGE)
    end
  end

  private

  def record_not_found
    redirect_to recipes_path
  end
end
