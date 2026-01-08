Rails.application.routes.draw do
  resources :transactions
  get "dashboard/index"
  devise_for :users
  authenticated :user do
    root to: "dashboard#index", as: :authenticated_root
  end

  resources :categories
  resources :transactions
  scope :onboarding do
    get  'start',    to: 'onboarding#start',    as: :onboarding_start
    post 'generate', to: 'onboarding#generate', as: :onboarding_generate
  end

  # Jika user belum login, root-nya adalah halaman login devise
  devise_scope :user do
    root to: "devise/sessions#new"
  end
end
