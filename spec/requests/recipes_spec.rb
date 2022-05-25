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

  # ===== ここから更新のテスト =====
  describe "POST #update" do
    subject { patch(recipe_path(recipe.id, params:)) }
    let!(:user) { create(:user) }
    let!(:recipe) { create(:recipe, user_id: user.id) }
    let!(:genre) { create(:genre, recipe_id: recipe.id) }
    let(:params) { { make_recipe_form: attributes_for(:recipe).merge(new_genre) } }
    let(:new_genre) { attributes_for(:genre) }

    context "レシピIDを渡してリクエストを投げたとき" do
      it "リクエストが成功する" do
        sign_in user
        subject
        expect(response).to have_http_status(:found)
      end
    end

    context "正常なパラメータを渡して『レシピ』を更新するとき" do
      # ===== レシピのタイトルを更新前と更新後で比較する =====
      it "レシピを更新した後、詳細ページにリダイレクトする" do
        sign_in user
        original_title = recipe.title
        new_title = params[:make_recipe_form][:title]
        expect { subject }.to change { recipe.reload.title }.from(original_title).to(new_title)
        expect(response).to redirect_to Recipe.last
      end
    end

    context "正常なパラメータを渡して『レシピのジャンル』を更新するとき" do
      let(:new_genre) { attributes_for(:genre, staple_food: "noodles") }

      # ===== ジャンルの主食を更新前と更新後で比較する =====
      it "レシピを更新した後、詳細ページにリダイレクトする" do
        sign_in user
        original_staple_food = recipe.genre.staple_food
        new_staple_food = params[:make_recipe_form][:staple_food]
        expect { subject }.to change { recipe.genre.reload.staple_food }.from(original_staple_food).to(new_staple_food)
        expect(response).to redirect_to Recipe.last
      end
    end

    context "不正な値を渡して更新を行ったとき" do
      let(:params) { { make_recipe_form: attributes_for(:recipe, :invalid).merge(new_genre) } }
      it "新しいレシピが更新されない" do
        sign_in user
        expect { subject }.not_to change(Recipe, :count)
      end
    end
  end

  # ===== ここから削除のテスト =====
  describe "DELETE #destroy" do
    subject { delete(recipe_path(recipe.id)) }
    let!(:user) { create(:user) }
    let!(:recipe) { create(:recipe, user_id: user.id) }
    let!(:genre) { create(:genre, recipe_id: recipe.id) }

    context "正常なパラメータを渡してリクエストを投げたとき" do
      it "リクエストが成功し、フラッシュメッセージを表示する" do
        sign_in user
        subject
        expect(response).to have_http_status(:found)
        expect(flash[:notice]).to be_present
      end
    end

    context "正常なパラメータを渡して削除を行ったとき" do
      it "削除が成功し、一覧ページへリダイレクトされる" do
        sign_in user
        expect { subject }.to change { Recipe.count }.by(-1)
        expect(response).to redirect_to recipes_path
      end
    end

    context "他人のレシピを渡して削除を行ったとき" do
      subject { delete(recipe_path(unknown_recipe.id)) }
      let!(:unknown_recipe) { create(:recipe) }
      let!(:unknown_genre) { create(:genre, recipe_id: unknown_recipe.id) }

      it "リクエストが成功し、一覧ページへリダイレクトした後フラッシュメッセージを表示する" do
        sign_in user
        subject
        expect(response).to have_http_status(:found)
        expect(response).to redirect_to recipes_path
        expect(flash[:alert]).to be_present
      end
    end
  end
end
