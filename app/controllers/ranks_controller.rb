class RanksController < ApplicationController
  TOP_FIVE_RANKINGS = 5
  def index
    @high_rank_recipes = Recipe.includes(:makes, :favorites).order(makes_count: :desc).limit(TOP_FIVE_RANKINGS)
  end
end
