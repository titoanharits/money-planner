Rails.application.routes.draw do
  devise_for :users, controllers: {
    registrations: 'users/registrations'
  }

  # Authenticated Routes
  authenticated :user do
    root "dashboard#index", as: :authenticated_root
    
    resource :settings, only: [:edit, :update]
    resources :pockets do
      member do
        post :adjust_balance
      end
    end
    resources :transactions
    resources :categories
  end

  get "dashboard/index"

  scope :onboarding do
    get  'start',    to: 'onboarding#start',    as: :onboarding_start
    post 'generate', to: 'onboarding#generate', as: :onboarding_generate
  end

  # Jika user belum login, root-nya adalah halaman login devise
  devise_scope :user do
    root to: "devise/sessions#new"
  end
end
