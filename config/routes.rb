Rails.application.routes.draw do
  root "homes#index"
  devise_for :users, controllers: {
    registrations: "users/registrations",
    passwords: "users/passwords"
  }
  devise_scope :user do
    post "users/guest_sign_in", to: "users/sessions#guest_sign_in"
  end

  resources :recipes do
    resource :makes, only: %i[create destroy]
    collection do
      get "search_index"
    end
  end
end
