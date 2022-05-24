require "rails_helper"

RSpec.describe "Recipes", type: :request do
  # ===== ここから一覧のテスト =====
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

  # ===== ここから詳細のテスト =====
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

  # ===== ここから新規投稿のテスト =====
  describe "GET #new" do
    subject { get(new_recipe_path) }
    let(:user) { create(:user) }

    context "リクエストを投げたとき" do
      it "リクエストが成功する" do
        sign_in user
        subject
        expect(response).to have_http_status(:ok)
      end
    end
  end

  describe "POST #create" do
    subject { post(recipes_path, params:) }
    let(:user) { create(:user) }

    # ===== パラメータが『正常』なとき =====
    context "正常なパラメータを渡してリクエストを投げるとき" do
      let(:params) { { make_recipe_form: attributes_for(:recipe).merge(genre) } }
      let(:genre) { attributes_for(:genre) }

      it "新規レシピが保存後、リダイレクトしフラッシュが表示される" do
        sign_in user
        expect { subject }.to change { Recipe.count }.by(1)
        expect(response).to have_http_status(:found)
        expect(response).to redirect_to recipes_path
        expect(flash[:notice]).to be_present
      end
    end

    # ===== パラメータが『異常』なとき =====
    context "異常なパラメータを渡してリクエストを投げたとき" do
      let(:params) { { make_recipe_form: attributes_for(:recipe, :invalid).merge(genre) } }
      let(:genre) { attributes_for(:genre) }

      it "新規レシピが保存されず、新規投稿ページがレンダリングされる" do
        sign_in user
        expect { subject }.not_to change(Recipe, :count)
        expect(response.body).to include "ジャンルを選択"
      end
    end
  end

  # ===== ここから編集のテスト =====
  describe "GET #edit" do
    subject { get(edit_recipe_path(recipe.id)) }
    let!(:user) { create(:user) }
    let!(:recipe) { create(:recipe, user_id: user.id) }
    let!(:genre) { create(:genre, recipe_id: recipe.id) }

    context "リクエストを投げたとき" do
      it "リクエストが成功する" do
        sign_in user
        subject
        expect(response).to have_http_status(:ok)
      end
    end

    context "レシピが存在するとき" do
      it "レシピのタイトル・コンテンツ・調理時間・目安費用・カロリーが表示される" do
        sign_in user
        subject
        expect(response.body).to include(
          recipe.title, recipe.content, recipe.cooking_time.to_s,
          recipe.cooking_cost.to_s, recipe.calorie.to_s
        )
      end
    end
  end
end
