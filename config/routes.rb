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
  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      # Váš stávající inventář rozšířený o audit_log
      resources :assets, path: "inventory", only: [ :index, :create, :update, :destroy ] do
        member do
          get :audit_log
        end
      end
      resources :buildings, only: [ :index ]
      resources :rooms, only: [ :index ]
    end
  end

  # Nastavení úvodní stránky (volitelné)
  root "buildings#index"
end