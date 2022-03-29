class Users::SessionsController < Devise::SessionsController
  # ゲストユーザでログインし一覧ページへ遷移
  def guest_sign_in
    sign_in User.guest
    redirect_to recipes_path, notice: "ゲストユーザとしてログインしました!"
  end
end
