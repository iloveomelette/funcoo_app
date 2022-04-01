class MakesController < ApplicationController
  def create
    current_user.makes.create!(recipe_id: params[:recipe_id])
    @recipe = Recipe.find(params[:recipe_id])
  end

  def destroy
    current_user.makes.find_by(recipe_id: params[:recipe_id]).destroy!
    @recipe = Recipe.find(params[:recipe_id])
  end
end
