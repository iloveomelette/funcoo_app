class MakesController < ApplicationController
  def create
    current_user.makes.create!(recipe_id: params[:recipe_id])
    current_point = current_user.experience_point
    adding_point = LevelSetting.calc_adding_point(current_user)
    current_point += adding_point
    current_user.update!(experience_point: current_point)
    next_level = LevelSetting.find_by(passing_level: current_user.level + 1)
    if next_level.threshold <= current_user.experience_point
      current_user.level += 1
      current_user.update!(level: current_user.level)
    end
    @recipe = Recipe.find(params[:recipe_id])
  end

  def destroy
    current_user.makes.find_by(recipe_id: params[:recipe_id]).destroy!
    @recipe = Recipe.find(params[:recipe_id])
  end
end
