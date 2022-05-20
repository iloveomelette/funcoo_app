require "rails_helper"

RSpec.describe User, type: :model do
  # ===== ここから保存できる時のテスト =====
  describe "全体のバリデーション" do
    let(:user) { build(:user) }

    context "characteristicの値を入力しないとき" do
      it "デフォルトのgeneralで保存できる" do
        expect(user[:characteristic]).to eq "general"
      end
    end

    context "levelの値を入力しないとき" do
      it "デフォルト値: 1で保存できる" do
        expect(user[:level]).to eq 1
      end
    end

    context "experience_pointの値を入力しないとき" do
      it "デフォルト値: 0で保存できる" do
        expect(user[:experience_point]).to eq 0
      end
    end

    context "rest_pointの値を入力しないとき" do
      it "デフォルト値: 30で保存できる" do
        expect(user[:rest_point]).to eq 30
      end
    end

    context "条件を満たすとき" do
      it "保存できる" do
        expect(user.valid?).to eq true
      end
    end
  end

  # ===== ここからエラーが発生するときのテスト =====
  describe "emailのバリデーション" do
    subject { user.valid? }

    context "空文字のとき" do
      let(:user) { build(:user, email: "") }
      it "エラーが発生する" do
        expect(subject).to eq false
        expect(user.errors.messages[:email]).to include "を入力してください"
      end
    end

    context "256文字以上のとき" do
      let(:user) { build(:user, email: "a" * 256) }
      it "エラーが発生する" do
        expect(subject).to eq false
        expect(user.errors.messages[:email]).to include "は255文字以内で入力してください"
      end
    end

    context "既に存在しているとき" do
      let(:user) { build(:user, email: "test@example.com") }
      it "エラーが発生する" do
        create(:user, email: "test@example.com")
        expect(subject).to eq false
        expect(user.errors.messages[:email]).to include "はすでに存在します"
      end
    end

    context "英数字のみのとき" do
      let(:user) { build(:user, email: "aaa") }
      it "エラーが発生する" do
        expect(subject).to eq false
        expect(user.errors.messages[:email]).to include "は不正な値です"
      end
    end
  end

  describe "passwordのバリデーション" do
    subject { user.valid? }

    context "空文字のとき" do
      let(:user) { build(:user, password: "") }
      it "エラーが発生する" do
        expect(subject).to eq false
        expect(user.errors.messages[:password]).to include "を入力してください"
      end
    end

    context "6文字より少ないとき" do
      let(:user) { build(:user, password: "aaa") }
      it "エラーが発生する" do
        expect(subject).to eq false
        expect(user.errors.messages[:password]).to include "は6文字以上で入力してください"
      end
    end
  end

  describe "nameのバリデーション" do
    subject { user.valid? }

    context "空文字のとき" do
      let(:user) { build(:user, name: "") }
      it "エラーが発生する" do
        expect(subject).to eq false
        expect(user.errors.messages[:name]).to include "を入力してください"
      end
    end

    context "51文字以上のとき" do
      let(:user) { build(:user, name: "a" * 51) }
      it "エラーが発生する" do
        expect(subject).to eq false
        expect(user.errors.messages[:name]).to include "は50文字以内で入力してください"
      end
    end
  end

  describe "introduction/urlのバリデーション" do
    subject { user.valid? }

    context "introductionが501文字以上のとき" do
      let(:user) { build(:user, introduction: "a" * 501) }
      it "エラーが発生する" do
        expect(subject).to eq false
        expect(user.errors.messages[:introduction]).to include "は500文字以内で入力してください"
      end
    end

    context "urlが2001文字以上のとき" do
      let(:user) { build(:user, url: "a" * 2001) }
      it "エラーが発生する" do
        expect(subject).to eq false
        expect(user.errors.messages[:url]).to include "は2000文字以内で入力してください"
      end
    end
  end

  # ===== ここから1対多の関係にあるRecipeモデルとのアソシエーションテスト =====
  describe "Recipeモデルとのアソシエーション" do
    context "ユーザが削除されたとき" do
      subject { user.destroy }

      let(:user) { create(:user) }
      before do
        create_list(:recipe, 2, user:)
        create(:recipe)
      end
      it "変数userが作成した2つのレシピが削除される" do
        expect { subject }.to change { user.recipes.count }.by(-2)
      end
    end
  end
end
