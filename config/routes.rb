Rails.application.routes.draw do
  root "homes#index"
  devise_for :users, controllers: {
    registrations: "users/registrations",
    passwords: "users/passwords",
    omniauth_callbacks: "users/omniauth_callbacks"
  }
  devise_scope :user do
    post "users/guest_sign_in", to: "users/sessions#guest_sign_in"
  end

  resources :recipes do
    resource :makes, only: %i[create]
    resource :favorites, only: %i[create destroy]
    collection do
      get "search_index"
    end
  end
  resources :users, only: %i[show]
  resources :ranks, only: %i[index]
end
