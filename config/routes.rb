Rails.application.routes.draw do
  get "dashboard/index"
  devise_for :users
  authenticated :user do
    root to: "dashboard#index", as: :authenticated_root
  end

  # Jika user belum login, root-nya adalah halaman login devise
  devise_scope :user do
    root to: "devise/sessions#new"
  end
end
