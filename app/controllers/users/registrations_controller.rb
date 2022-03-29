class Users::RegistrationsController < Devise::RegistrationsController
  before_action :ensure_normal_user, only: :destroy

  def ensure_normal_user
    redirect_to recipes_path, alert: "ゲストユーザは削除できません" if resource.email == "guest@example.com"
  end
end
