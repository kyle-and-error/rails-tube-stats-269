Rails.application.routes.draw do
  get 'suggestions/index'
  get 'suggestions/show'
  devise_for :users

  resources :youtube_accounts
  root to: 'pages#home'
  get 'data', to: 'pages#data'
  get 'dashboard', to: 'pages#dashboard'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
