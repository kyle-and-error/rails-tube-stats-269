Rails.application.routes.draw do
  get 'youtube_accounts/index'
  get 'youtube_accounts/new'
  get 'youtube_accounts/show'
  devise_for :users
  root to: 'pages#home'
  get "data", to: "pages#data"
  get "dashboard", to: "pages#dashboard"
  get "google4165ccca5ea2416c.html", to: "pages#google_verification"
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
