Rails.application.routes.draw do
  resources :finance_states
  resources :accounts
  resources :monthly_statistics
  resources :items
  resources :intervals
  resources :categories
  
  root 'items#index'
  
  resources :items do
    collection { post :import }
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
