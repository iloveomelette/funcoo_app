module UsersHelper
  MAKED_RECIPES = "作ってみたを押したレシピ".freeze
  POST_RECIPES = "投稿したレシピ".freeze
  PROMOTE_MAKE = "「作ってみた！」を押すと、ここにその投稿が表示されます。".freeze
  PROMOTE_POST = "レシピを投稿すると、ここにそのレシピが表示されます。".freeze

  def check_user_characteristic(current_user)
    current_user.characteristic == "general" ? MAKED_RECIPES : POST_RECIPES
  end

  def promote_msg(current_user)
    current_user.characteristic == "general" ? PROMOTE_MAKE : PROMOTE_POST
  end

  def check_user_profile_image(user)
    original_image = user.profile_image.thumb.url
    default_image = user.profile_image.url
    user.profile_image.present? ? original_image : default_image
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
