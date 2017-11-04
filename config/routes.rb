Rails.application.routes.draw do
  root 'guess#index'
  resources :guess, only: [:create]
  resources :stats, only: [:index]

  get 'home', to: 'application#index'
end
