Rails.application.routes.draw do
  if Rails.env.test?
    namespace :test do
      resource :session, only: %i[create]
    end
  end

  root 'movies#index'
  resources :movies
  resources :votes, only: [:create, :destroy]
  resources :categories, path: 'genres', only: [:show, :create, :update, :destroy]
  get 'sign_up', to: 'registrations#new'
  post 'sign_up', to: 'registrations#create'
  get 'sign_in', to: 'sessions#new'
  post 'sign_in', to: 'sessions#create', as: 'log_in'
  delete 'logout', to: 'sessions#destroy'
end
