Rails.application.routes.draw do
  devise_for :users

  # Show user profile, accessible only if the user is authenticated
  resources :users, only: [:show], constraints: { id: /\d+/ } do
    # Nested reports routes under users
    resources :reports, only: [:index, :show, :new, :create, :edit, :update, :destroy] do
      collection do
        # Route to generate analysis based on input
        post 'generate_analysis', to: 'reports#generate_analysis'

        # Route to extract scores from uploaded PDF
        post 'extract_scores', to: 'reports#extract_scores'
      end

      # Route to generate PDF for the individual report
      member do
        get :generate_pdf, defaults: { format: :js }
      end
    end
  end

  # Health check route
  get "up" => "rails/health#show", as: :rails_health_check

  # Root path
  root "home#index"
end

