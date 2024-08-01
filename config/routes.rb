Rails.application.routes.draw do
  get 'telegram/new'
  get 'telegram/create'
  devise_for :users, controllers: {
    sessions: 'users/sessions'
  }

  root to: 'websites#index'

  resources :websites
  resources :tags
  resources :users

  devise_scope :user do
    get '/signout', to: 'users/sessions#destroy', as: :signout
  end

  mount LetterOpenerWeb::Engine, at: "/letter_opener" if Rails.env.development?

  post '/telegram/webhook', to: 'telegram#webhook'

  namespace :api do
    namespace :v1 do
      resources :websites, only: [:create]
    end
  end
end
