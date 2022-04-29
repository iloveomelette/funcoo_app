class Users::RegistrationsController < Devise::RegistrationsController
  before_action :ensure_normal_user, only: %i[update destroy]

  # destroy,updateアクションが実行される前にゲストユーザか確認をする処理
  def ensure_normal_user
    redirect_to recipes_path, alert: "ゲストユーザは更新・削除できません" if resource.email == "guest@example.com"
  end

  protected

  def update_resource(resource, params)
    resource.update_without_current_password(params)
  end

  # マイページを作成できたらマイページに遷移させる
  def after_update_path_for(_resource)
    recipes_path
  end
end
