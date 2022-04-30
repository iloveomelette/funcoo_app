module UsersHelper
  MAKED_RECIPES = "作ってみたを押したレシピ".freeze
  POST_RECIPES = "投稿したレシピ".freeze

  def check_user_characteristic(current_user)
    current_user.characteristic == "general" ? MAKED_RECIPES : POST_RECIPES
  end

  def check_user_profile_image(current_user)
    original_image = current_user.profile_image.thumb.url
    default_image = current_user.profile_image.url
    current_user.profile_image.present? ? original_image : default_image
  end
end
