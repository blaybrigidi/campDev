Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  # root "posts#index"

  # Create all CRUD endpoints for user
  resources :users
  # Create all CRUD endpoints for orders
  resources :orders do
    collection do
      get :by_user
      get :marketplace      # View all pending orders
      get :my_services      # View orders I'm servicing
    end
    member do
      patch :accept_order   # Accept a specific order
    end
    resources :messages, only: [:index, :create]  # Nested messages for orders
  end

   # Endpoint for login
   post "/login", to: "sessions#login"

   # Endpoint to cancel order
   patch "/orders/:id/cancel", to: "orders#cancel"

   # Endpoint to update order
   patch "orders/:id/update", to: "orders#update"
end
