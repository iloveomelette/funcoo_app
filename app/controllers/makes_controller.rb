class MakesController < ApplicationController
  def create
    @recipe = Recipe.find(params[:recipe_id])
    current_user.makes.create!(recipe_id: @recipe.id)
  end

  def destroy
    @recipe = Recipe.find(params[:recipe_id])
    current_user.makes.find_by(recipe_id: @recipe.id).destroy!
  end
end
