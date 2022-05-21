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

  # ===== ここから詳細ページのテスト =====
  describe "GET #show" do
    subject { get(recipe_path(recipe_id)) }
    let(:user) { create(:user) }
    let(:recipe) { create(:recipe) }
    let(:recipe_id) { recipe.id }

    context "レシピIDを渡してリクエストを投げたとき" do
      it "リクエストが成功する" do
        sign_in user
        subject
        expect(response).to have_http_status(:ok)
      end
    end

    context "存在しないレシピIDを渡してリクエストを投げたとき" do
      let(:recipe_id) { 4 }
      it "リクエストが失敗する" do
        sign_in user
        expect { subject }.to raise_error ActiveRecord::RecordNotFound
      end
    end

    context "レシピが存在するとき" do
      it "レシピの情報が表示される" do
        sign_in user
        subject
        expect(response.body).to include(
          recipe.title, recipe.content, recipe.cooking_time.to_s,
          recipe.cooking_cost.to_s, recipe.calorie.to_s, recipe.makes_count.to_s
        )
      end

      it "投稿者の名前・URLが表示される" do
        sign_in user
        subject
        expect(response.body).to include(
          recipe.user.name, recipe.user.url
        )
      end
    end
  end
end
