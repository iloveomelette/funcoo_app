class RanksController < ApplicationController
  TOP_FIVE_RANKINGS = 5
  def maked_ranking
    recipe_ids = Recipe.order(makes_count: :desc).limit(TOP_FIVE_RANKINGS).pluck(:id)
    @high_rank_recipes = Recipe.includes(:makes, :favorites).find(recipe_ids)
  end
end
