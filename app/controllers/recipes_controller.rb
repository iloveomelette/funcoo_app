class RecipesController < ApplicationController
  before_action :set_recipe, only: %i[edit update destroy]

  def index
    @recipes = Recipe.includes(:user, :makes).order(created_at: :desc)
    # レコメンド機能の呼び出し
    @recommend = Recipe.recommend(current_user) if current_user.characteristic == "general"
  end

  def new
    @recipe = MakeRecipeForm.new
  end

  def create
    @recipe = MakeRecipeForm.new(recipe_params)
    if @recipe.valid?
      @recipe.save
      redirect_to recipes_path, notice: "投稿しました!"
    else
      render :new
    end
  end

  def show
    @recipe = Recipe.find(params[:id])
  end

  def edit; end

  def update
    @recipe.update!(recipe_params)
    redirect_to @recipe
  end

  def destroy
    if @recipe.destroy
      redirect_to recipes_path, notice: "削除成功!"
    else
      redirect_to recipes_path, alert: "削除に失敗しました!"
    end
  end

  private

  def recipe_params
    params.require(:make_recipe_form).permit(:title, :content, :menu_image, :cooking_time, :cooking_cost, :calorie).merge(user_id: current_user.id)
  end

  # 自身のIDに対応する投稿を取得するメソッド
  def set_recipe
    @recipe = current_user.recipes.find_by(id: params[:id])
    redirect_to recipes_path, alert: "権限がありません" if @recipe.nil?
  end
end
