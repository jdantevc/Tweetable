Rails.application.routes.draw do
  resources :likes
  devise_for :users, controllers: { omniauth_callbacks: :callbacks }

  resources :users
  resources :tweets
  
  root "tweets#index"

  resources :tweets do
    post 'reply', on: :member
  end
end