module UsersHelper
  MAKED_RECIPES = "作ってみたを押したレシピ".freeze
  POST_RECIPES = "投稿したレシピ".freeze
  PROMOTE_MAKE = "「作ってみた！」を押すと、ここにその投稿が表示されます。".freeze
  PROMOTE_POST = "レシピを投稿すると、ここにそのレシピが表示されます。".freeze
  GUEST_PROFILE_IMAGE = "guest_profile_image.png".freeze

  def check_user_characteristic(current_user)
    current_user.characteristic == "general" || current_user.email == "guest@example.com" ? MAKED_RECIPES : POST_RECIPES
  end

  def promote_msg(current_user)
    current_user.characteristic == "general" ? PROMOTE_MAKE : PROMOTE_POST
  end

  # ===== ここからログインユーザのプロフィール画像をチェックする処理 =====
  def check_user_profile_image(user)
    user.email == "guest@example.com" ? guest_user_profile_image : original_user_profile_image(user)
  end

  def original_user_profile_image(user)
    user.profile_image.present? ? user.profile_image.thumb.url : user.profile_image.url
  end

  def guest_user_profile_image
    GUEST_PROFILE_IMAGE
  end
  # ===== ここまで =====

  def verify_user_introduction(user)
    user.introduction.present? ? safe_join(user.introduction.split("\n"), tag.br) : user.introduction
  end

  def show_favorited_recipes
    return unless current_page?(action: "mypage")

    tag.li do
      tag.a "お気に入りしたレシピ", href: "#", "data-id": "favorite-recipes"
    end
  end

  def show_paginate(recipes)
    return unless recipes.count == ApplicationController::PER_PAGE

    tag.div class: "paginate pt-10" do
      paginate recipes
    end
  end
end
