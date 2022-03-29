class Users::PasswordsController < Devise::PasswordsController
  before_action :ensure_normal_user, only: :create

  # パスワード再設定に入力されたメールアドレスがゲストユーザかどうか確認する処理
  def ensure_normal_user
    redirect_to new_user_session_path, alert: "ゲストユーザのパスワードは再設定できません" if params[:user][:email].casecmp("guest@example.com").zero?
  end
end
