class Recommend < ApplicationRecord
  LATEST_USER_IDS = 5
  NEXT_TO_LOGIN_USER = 1
  SUBSTITUTE_RECIPE_ID = 1
  TWO_WEEKS_DINNER = 14
  belongs_to :user
  # クラス内Lineが長くなりすぎるため、with_optionsは使わずに対応(NOTNULL制約のバリデーション)
  validates :recommend_recipe, :avg_staple, :avg_main, :avg_side, :avg_country,
            :sum_staple, :sum_main, :sum_side, :sum_country, presence: true

  class << self
    def store_recipe_id(recipe_id, current_user)
      maked_recipe, sum_makes, recommend_columns = set_variable(recipe_id, current_user)
      sum_columns = calc_recommend_sum_columns(maked_recipe, recommend_columns)
      avg_columns = calc_recommend_average_columns(sum_makes, sum_columns)

      # 作ってみたを押した投稿に同じく作ってみたを押した最新5人のユーザIDを抽出する
      user_ids = Make.where(recipe_id:).order(created_at: :desc).limit(LATEST_USER_IDS).offset(NEXT_TO_LOGIN_USER).pluck(:user_id)
      if user_ids.present?
        # ターゲットとなるログインユーザの平均ジャンル(avg_staple...)を実引数として渡す
        similarity_results = calc_cosine_similarity(user_ids, avg_columns)
        recommend_recipe_id = select_recommend_recipe(user_ids, similarity_results, current_user)
        update_recommend_recipe(recommend_recipe_id, recommend_columns, avg_columns, sum_columns)
      else
        substitute_for_recipe = substitute_for_recipe(avg_columns)
        update_recommend_columns(recommend_columns, substitute_for_recipe.id, avg_columns, sum_columns)
      end
    end

    # ====== ここからprivateクラスメソッド ======

    # 必要になる変数を取得する処理
    def set_variable(recipe_id, current_user)
      maked_recipe = Genre.find_by(recipe_id:)
      sum_makes = Make.where(user_id: current_user.id).count(:user_id)
      recommend_columns = Recommend.find_or_create_by!(user_id: current_user.id)
      [maked_recipe, sum_makes, recommend_columns]
    end

    # これまで選択したジャンル番号の合計を計算する処理
    def calc_recommend_sum_columns(maked_recipe, recommend_columns)
      sum_staple = recommend_columns.sum_staple + maked_recipe.staple_food_before_type_cast
      sum_main = recommend_columns.sum_main + maked_recipe.main_dish_before_type_cast
      sum_side = recommend_columns.sum_side + maked_recipe.side_dish_before_type_cast
      sum_country = recommend_columns.sum_country + maked_recipe.country_dish_before_type_cast
      [sum_staple, sum_main, sum_side, sum_country]
    end

    # 作ってみたを押した時に、これまで選択したジャンル番号の合計からsum_makesで割る処理 => 平均ジャンル番号を計算する
    def calc_recommend_average_columns(sum_makes, sum_columns)
      avg_staple = sum_columns[0] / sum_makes.to_f
      avg_main = sum_columns[1] / sum_makes.to_f
      avg_side = sum_columns[2] / sum_makes.to_f
      avg_country = sum_columns[3] / sum_makes.to_f
      [avg_staple, avg_main, avg_side, avg_country]
    end

    def calc_cosine_similarity(user_ids, target)
      # 一人一人の平均ジャンル(avg_staple...)を取得する
      partners_avg_columns = []
      user_ids.each do |user_id|
        partners_avg_columns << Recommend.find_by(user_id:)
      end

      # 比較対象のパートナーとなるユーザの平均ジャンル(avg_staple...)を格納する
      similarity_results = []
      partners_avg_columns.each do |column|
        partner = [column.avg_staple, column.avg_main, column.avg_side, column.avg_country]
        calc_result = cosine_similarity(target, partner).round(3)
        similarity_results << calc_result
      end
      similarity_results
    end

    def select_recommend_recipe(user_ids, similarity_results, current_user)
      # 格納した結果の中で最も1に近い値のインデックス番号を取得する
      num = 1
      result = similarity_results.min_by { |x| (x - num).abs }
      # user_idsのインデックス番号と同じ要素を取り出してユーザIDを抽出する
      index_num = similarity_results.find_index(result)
      # user_idsのインデックス番号を指定してユーザIDを抽出する
      friendly_user_id = user_ids[index_num]
      # friendly_userが「作ってみた」を押したレシピIDを取得する
      recommend_recipes = Make.where(user_id: friendly_user_id).order(created_at: :desc).limit(TWO_WEEKS_DINNER).pluck(:recipe_id)
      # ログインユーザが作ってみたを押したレシピID(最新14件)を取得する
      target_maked_recipes = Make.where(user_id: current_user.id).order(created_at: :desc).limit(TWO_WEEKS_DINNER).pluck(:recipe_id)
      # ログインユーザがまだ「作ってみた」を押していない最新のレシピIDを抽出する
      recommend_recipes - target_maked_recipes
    end

    def update_recommend_recipe(recommend_recipe_id, recommend_columns, avg_columns, sum_columns)
      # recommend_recipe_idを最新のおすすめレシピIDとしてカラムに保存する
      if recommend_recipe_id.present?
        update_recommend_columns(recommend_columns, recommend_recipe_id.last, avg_columns, sum_columns)
      else
        substitute_for_recipe = substitute_for_recipe(avg_columns)
        update_recommend_columns(recommend_columns, substitute_for_recipe.id, avg_columns, sum_columns)
      end
    end

    # ===== 比較対象の他ユーザがいない、おすすめレシピIDがない時の代わりのレシピを取得する処理 =====
    def substitute_for_recipe(avg_columns)
      recipe_id = Genre.where(staple_food: avg_columns[0].round(0)).order(created_at: :desc).limit(SUBSTITUTE_RECIPE_ID).pluck(:recipe_id)
      Recipe.find_by(id: recipe_id)
    end

    def update_recommend_columns(recommend_columns, recommend_recipe, avg_columns, sum_columns)
      recommend_columns.update(recommend_recipe:, avg_staple: avg_columns[0], avg_main: avg_columns[1], avg_side: avg_columns[2],
                               avg_country: avg_columns[3], sum_staple: sum_columns[0], sum_main: sum_columns[1],
                               sum_side: sum_columns[2], sum_country: sum_columns[3])
    end

    # ===== 以下3つのメソッドがコサイン類似度の計算処理 =====
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
  private_class_method :set_variable, :calc_recommend_sum_columns, :calc_recommend_sum_columns,
                       :calc_cosine_similarity, :cosine_similarity, :dot_product, :normalize,
                       :select_recommend_recipe, :update_recommend_recipe, :substitute_for_recipe, :update_recommend_columns
end
