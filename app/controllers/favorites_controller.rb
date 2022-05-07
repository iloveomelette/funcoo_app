class FavoritesController < ApplicationController
  def create
    current_user.favorites.create!(recipe_id: params[:recipe_id])
    redirect_back(fallback_location: recipes_path)
  end

  def destroy
    current_user.favorites.find_by(recipe_id: params[:recipe_id]).destroy!
    redirect_back(fallback_location: recipes_path)
  end
end
