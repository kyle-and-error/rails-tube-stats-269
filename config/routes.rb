Rails.application.routes.draw do
  devise_for :users
  resources :suggestions, only: [:index, :show]
  resources :youtube_accounts
  root to: 'pages#home'
  get 'privacy_policy', to: 'pages#privacy_policy'
  get 'data', to: 'pages#data'
  get 'dashboard', to: 'pages#dashboard'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
