class Users::RegistrationsController < Devise::RegistrationsController
  before_action :ensure_normal_user, only: %i[update destroy]

  # destroy,updateアクションが実行される前にゲストユーザか確認をする処理
  def ensure_normal_user
    redirect_to recipes_path, alert: "ゲストユーザは更新・削除できません" if resource.email == "guest@example.com"
  end
end
