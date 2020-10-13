Rails.application.routes.draw do
  get 'users/show'
  root 'posts#index'
  get 'dashboard', to: 'posts#dashboard'
  get '/admin', to: 'admin/users#index'

  devise_scope :user do
    get '/users/two_factor/confirm' => 'users/registrations#confirm_two_factor',
      as: :confirm_two_factor

    put '/users/two_factor' => 'users/registrations#confirm_two_factor_update',
      as: :confirm_two_factor_update

  end

  devise_for :users, controllers: {
    omniauth_callbacks: "users/omniauth_callbacks",
    registrations: 'users/registrations',
    sessions: 'users/sessions'
  }

  resources :users, only: %i[show]

  resources :posts do
    get '/top/posts',  controller: 'posts', action: 'top', on: :collection
    collection do
      get :status
    end
    resources :comments
    resources :likes
    resources :rates, only: :create
  end

  resources :categories do
    resources :posts
  end

  namespace :admin do
    resources :users, :posts, :categories
  end
end
