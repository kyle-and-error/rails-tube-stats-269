Rails.application.routes.draw do
  devise_for :users
  resources :user, only: [:show, :edit, :update, :destroy] do
    resources :youtube_accounts, only: [:new, :edit, :update, :show] do
      get 'data', to: 'pages#data'
      resources :suggestions, only:[:index, :show]
    end
    get 'dashboard', to: 'pages#dashboard'
  end
  get 'privacy_policy', to: 'pages#privacy_policy'
  resources :youtube_accounts
  root to: 'pages#home'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
