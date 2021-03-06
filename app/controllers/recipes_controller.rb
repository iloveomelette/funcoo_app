class RecipesController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[index]
  before_action :set_recipe, only: %i[edit update destroy]

  def index
    # PER_PAGEの参照先： ApplicationController
    @recipes = Recipe.includes(:user, :makes, :favorites).order(created_at: :desc).page(params[:page]).per(PER_PAGE)
    return unless user_signed_in? && current_user.characteristic == "general"

    recommend_recipe_id = Recommend.where(user_id: current_user.id).pluck(:recommend_recipe)
    @recommend = Recipe.find_by(id: recommend_recipe_id)
  end

  def new
    @recipe_form = MakeRecipeForm.new
  end

  def create
    @recipe_form = MakeRecipeForm.new(recipe_params)
    if @recipe_form.valid?
      @recipe_form.save
      redirect_to recipes_path, notice: "投稿しました!"
    else
      render :new
    end
  end

  def show
    @recipe = Recipe.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to recipes_path
  end

  def edit
    @recipe_form = MakeRecipeForm.new(recipe: @recipe)
  end

  def update
    @recipe_form = MakeRecipeForm.new(recipe_params, recipe: @recipe)
    if @recipe_form.valid?
      @recipe_form.update_recipe
      redirect_to @recipe, notice: "更新しました!"
    else
      render :edit
    end
  end

  def destroy
    if @recipe.destroy
      redirect_to recipes_path, notice: "削除成功!"
    else
      redirect_to recipes_path, alert: "削除に失敗しました!"
    end
  end

  def search_index; end

  private

  def recipe_params
    params.require(:make_recipe_form).permit(
      :title, :content, :menu_image, :cooking_time,
      :cooking_cost, :calorie,
      :staple_food, :main_dish, :side_dish, :country_dish
    ).merge(user_id: current_user.id)
  end

  # 自身のIDに対応する投稿を取得するメソッド
  def set_recipe
    @recipe = current_user.recipes.find_by(id: params[:id])
    redirect_to recipes_path, alert: "権限がありません" if @recipe.nil?
  end
end
