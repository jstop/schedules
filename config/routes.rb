Rails.application.routes.draw do
  resources :routines

  root to: 'routines#index'
  devise_for :users
  resources :users
end
