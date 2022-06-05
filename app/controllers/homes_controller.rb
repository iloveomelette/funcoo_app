class HomesController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[index]
  TOP_LATEST_RECIPES = 3

  def index
    @recipes = Recipe.includes(:user).order(created_at: :desc).limit(TOP_LATEST_RECIPES)
  end
end
