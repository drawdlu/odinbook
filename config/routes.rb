Rails.application.routes.draw do
  devise_for :users, controllers: {
    omniauth_callbacks: "users/omniauth_callbacks",
    registrations: "users/registrations"
  }

  root "posts#index"

  resources :users, only: [ :index ] do
    resources :followers, only: [ :index ], controller: "follows/followers"
    resources :followings, only: [ :index ], controller: "follows/followings"
    resource :profile
  end
  resource :username, only: [ :edit, :update ], controller: "users/usernames"
  resources :follow_requests, only: [ :index, :update, :destroy ], controller: "follows/follow_requests"

  resources :posts do
    resources :comments do
      member do
        get :delete_button
      end
    end
  end

  resources :likes, only: [ :create, :destroy ]

  resources :follows, only: [ :create, :destroy ] do
    member do
      get :links
    end
  end

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  # root "posts#index"
end
