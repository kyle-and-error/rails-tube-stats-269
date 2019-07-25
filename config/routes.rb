Rails.application.routes.draw do
  devise_for :users

  resources :youtube_accounts
  root to: 'pages#home'
  get 'data', to: 'pages#data'
  get 'dashboard', to: 'pages#dashboard'
  get 'google4165ccca5ea2416c.html', to: 'pages#google_verification'

  get 'authorize', to: 'pages#authorize'
  get 'oauth2callback', to: 'pages#oauth'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
