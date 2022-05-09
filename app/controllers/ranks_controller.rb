class RanksController < ApplicationController
  def maked_ranking
    recipe_ids = Recipe.order(makes_count: :desc).limit(5).pluck(:id)
    @high_rank_recipes = Recipe.includes(:makes, :favorites).find(recipe_ids)
  end
end
