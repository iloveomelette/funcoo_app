class MakesController < ApplicationController
  def create
    current_user.makes.create!(recipe_id: params[:recipe_id])
    LevelSetting.calc_level(current_user)
    Recommend.store_recipe_id(params[:recipe_id], current_user)
    @recipe = Recipe.find(params[:recipe_id])
  end

  def destroy
    current_user.makes.find_by(recipe_id: params[:recipe_id]).destroy!
    LevelSetting.down_level(current_user)
    @recipe = Recipe.find(params[:recipe_id])
  end
end
