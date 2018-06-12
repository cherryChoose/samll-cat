Rails.application.routes.draw do

  devise_for :users, path: "account", controllers: {
      omniauth_callbacks: "auth/omniauth_callbacks"
  }
  get 'store/index', as: :store_index

  resources :line_items do
    member do
      patch :change_quantity
      post :change_quantity
    end
  end
  resources :carts

  resources :products

  resources :orders

  root to: 'store#index'
end
