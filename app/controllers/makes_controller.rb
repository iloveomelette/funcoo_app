class MakesController < ApplicationController
  def create
    current_user.makes.create!(recipe_id: params[:recipe_id])
    LevelSetting.calc_level(current_user)

    # 必要になる変数を取得しておく
    maked_recipe = Genre.find_by(recipe_id: params[:recipe_id])
    sum_makes = Make.where(user_id: current_user.id).count(:user_id)
    recommend_columns = Recommend.find_or_create_by!(user_id: current_user.id)

    # これまで選択したジャンル番号の合計を更新する処理
    sum_staple = recommend_columns.sum_staple + maked_recipe.staple_food_before_type_cast
    sum_main = recommend_columns.sum_main + maked_recipe.main_dish_before_type_cast
    sum_side = recommend_columns.sum_side + maked_recipe.side_dish_before_type_cast
    sum_country = recommend_columns.sum_country + maked_recipe.country_dish_before_type_cast

    # 作ってみたを押した時に、これまで選択したジャンル番号の合計からsum_makesで割る => 平均ジャンル番号
    avg_staple = sum_staple / sum_makes.to_f
    avg_main = sum_main / sum_makes.to_f
    avg_side = sum_side / sum_makes.to_f
    avg_country = sum_country / sum_makes.to_f

    # 作ってみたを押した投稿に同じく作ってみたを押した最新5人のユーザIDを抽出する
    user_ids = Make.where(recipe_id: params[:recipe_id]).order(created_at: :desc).limit(5).offset(1).pluck(:user_id)
    if user_ids.present?
      # 一人一人の平均ジャンル(avg_staple...)を取得する
      partners_avg_columns = []
      user_ids.each do |user_id|
        partners_avg_columns << Recommend.find_by(user_id:)
      end

      # ターゲットとなるログインユーザの平均ジャンル(avg_staple...)を格納する
      target = [avg_staple, avg_main, avg_side, avg_country]
      # 比較対象のパートナーとなるユーザの平均ジャンル(avg_staple...)を格納する
      similarity_results = []
      partners_avg_columns.each do |column|
        partner = [column.avg_staple, column.avg_main, column.avg_side, column.avg_country]
        calc_result = cosine_similarity(target, partner).round(3)
        similarity_results << calc_result
      end

      # 格納した結果の中で最も1に近い値のインデックス番号を取得する
      num = 1
      result = similarity_results.min_by { |x| (x - num).abs }
      # user_idsのインデックス番号と同じ要素を取り出してユーザIDを抽出する
      index_num = similarity_results.find_index(result)

      # user_idsのインデックス番号を指定してユーザIDを抽出する
      friendly_user_id = user_ids[index_num]

      # friendly_userが「作ってみた」を押したレシピIDを取得する
      recommend_recipes = Make.where(user_id: friendly_user_id).order(created_at: :desc).limit(14).pluck(:recipe_id)
      # recommend_recipesの中でログインユーザがまだ「作ってみた」を押していない最新のレシピIDを抽出する
      # ログインユーザが作ってみたを押したレシピID(最新14件)を取得する
      target_maked_recipes = Make.where(user_id: current_user.id).order(created_at: :desc).limit(14).pluck(:recipe_id)

      # ログインユーザがまだ「作ってみた」を押していない最新のレシピIDを抽出する
      recommend_recipe_id = recommend_recipes - target_maked_recipes

      # recommend_recipe_idを最新のおすすめレシピIDとしてカラムに保存する
      if recommend_recipe_id.present?
        recommend_columns.update(recommend_recipe: recommend_recipe_id.last, avg_staple:, avg_main:, avg_side:, avg_country:
        , sum_staple:, sum_main:, sum_side:, sum_country:)
      else
        substitute_for_recipe = Recipe.find_by(id: Genre.where(staple_food: avg_staple.round(0)).order(created_at: :desc).limit(1).pluck(:recipe_id))
        recommend_columns.update(recommend_recipe: substitute_for_recipe.id, avg_staple:, avg_main:, avg_side:, avg_country:
        , sum_staple:, sum_main:, sum_side:, sum_country:)
      end
    else
      substitute_for_recipe = Recipe.find_by(id: Genre.where(staple_food: avg_staple.round(0)).order(created_at: :desc).limit(1).pluck(:recipe_id))
      recommend_columns.update(recommend_recipe: substitute_for_recipe.id, avg_staple:, avg_main:, avg_side:, avg_country:
      , sum_staple:, sum_main:, sum_side:, sum_country:)
    end

    @recipe = Recipe.find(params[:recipe_id])
  end

  def destroy
    current_user.makes.find_by(recipe_id: params[:recipe_id]).destroy!
    LevelSetting.down_level(current_user)
    @recipe = Recipe.find(params[:recipe_id])
  end

  private

  def cosine_similarity(target, partner)
    dp = dot_product(target, partner)
    nm = normalize(target) * normalize(partner)
    dp / nm
  end

  def dot_product(target, partner)
    sum = 0.0
    target.each_with_index { |val, i| sum += val * partner[i] }
    sum
  end

  def normalize(vector)
    Math.sqrt(vector.inject(0.0) { |result, item| result + (item**2) })
  end
end
