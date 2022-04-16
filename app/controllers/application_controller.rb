class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :search
  PER_PAGE = 20

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [
                                        :name,
                                        :characteristic,
                                        :introduction,
                                        :profile_image
                                      ])
    devise_parameter_sanitizer.permit(:account_update, keys: [
                                        :name,
                                        :characteristic,
                                        :introduction,
                                        :profile_image
                                      ])
  end

  def search
    @q = Recipe.ransack(params[:q])
    @searched_recipes = @q.result.includes(:user, :makes).order(created_at: :desc).page(params[:page]).per(PER_PAGE)
  end

  def after_sign_in_path_for(_resource)
    recipes_path
  end
end
