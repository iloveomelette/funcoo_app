class UsersController < ApplicationController
  before_action :set_contributor, only: :show

  def show
    @contributor_recipes = take_contributor_recipes(@contributor.id)
  end

  def mypage
    @recipes = take_user_recipes
    recipe_ids = Favorite.includes(:user).where(user_id: current_user.id).order(created_at: :desc).pluck(:recipe_id)
    @favorite_recipes = Recipe.includes(:makes, :favorites).where(id: recipe_ids).page(params[:page]).per(PER_PAGE)
  end

  private

  def take_user_recipes
    if current_user.characteristic == "general"
      Recipe.includes(:user, :makes, :favorites).where(id: current_user.maked_recipes.pluck(:recipe_id)).page(params[:page]).per(PER_PAGE)
    else
      Recipe.includes(:user, :makes, :favorites).where(user_id: current_user.id).order(created_at: :desc).page(params[:page]).per(PER_PAGE)
    end
  end

  def set_contributor
    @contributor = User.find_by(id: params[:id])
  end

  def take_contributor_recipes(user_id)
    Recipe.includes(:user, :makes, :favorites).where(user_id:).order(created_at: :desc).page(params[:page]).per(PER_PAGE)
  end
end
