Rails.application.routes.draw do
  devise_for :users
  # 1. Cesty pro webový prohlížeč (HTML)
  resources :buildings
  resources :rooms
  resources :assets, path: "inventory"
  resources :users

  resources :assets do
    member do
      delete :purge_attachment
    end
  end

  # 2. Cesty pro API (JSON)
  namespace :api do
    namespace :v1 do
      resources :assets, path: "inventory", only: [:index, :create, :update, :destroy]
    end
  end

  # Nastavení úvodní stránky (volitelné)
  root "buildings#index"
end