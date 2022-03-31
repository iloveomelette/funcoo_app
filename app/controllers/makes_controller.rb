class MakesController < ApplicationController
  def create
    current_user.makes.create!(recipe_id: params[:recipe_id])
    redirect_back(fallback_location: recipes_path)
  end

  def destroy
    current_user.makes.find_by(recipe_id: params[:recipe_id]).destroy!
    redirect_back(fallback_location: recipes_path)
  end
end
