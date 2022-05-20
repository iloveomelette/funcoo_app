require "rails_helper"

RSpec.describe "Recipes", type: :request do
  # ===== ここから一覧ページのテスト =====
  describe "GET #index" do
    subject { get(recipes_path) }

    context "リクエストを投げたとき" do
      it "リクエストが成功する" do
        subject
        expect(response).to have_http_status(:ok)
      end
    end

    context "レシピが存在するとき" do
      let!(:recipe) { create(:recipe) }
      it "レシピの情報が表示されている" do
        subject
        expect(response.body).to include(
          recipe.title, recipe.content, recipe.cooking_time.to_s,
          recipe.cooking_cost.to_s, recipe.calorie.to_s, recipe.makes_count.to_s
        )
      end
    end
  end
end
