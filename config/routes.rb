Rails.application.routes.draw do
  devise_for :users

  resources :youtube_accounts
  root to: 'pages#home'
  get "data", to: "pages#data"
  get "dashboard", to: "pages#dashboard"
  get "google4165ccca5ea2416c.html", to: "pages#google_verification"
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
