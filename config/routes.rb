Rails.application.routes.draw do
  get 'users/show'
  devise_for :users

  # Nest reports under users, but only if users are authenticated
  resources :users, only: [:show], constraints: { id: /\d+/ } do
    resources :reports, only: [:index, :show, :new, :create, :edit, :update] do
      collection do
        post 'generate_analysis', to: 'reports#generate_analysis'
      end
    end
  end

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  root "home#index"
end
