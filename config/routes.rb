Rails.application.routes.draw do
  get 'dashboard/dashboard'
  
  resources :navigations
  resources :finance_states
  resources :accounts
  resources :monthly_statistics
  resources :items
  resources :intervals
  resources :categories
  
  root 'dashboard#dashboard'
  
  get '/calculate_amount', to: 'items#calculate_amount'

  #get '/delete_all', to: 'monthly_statistics#delete_all'
  
  resources :items do
    collection { post :import }  
  end
  
  resources :categories do
    collection { post :import }
  end
  
  resources :intervals do
    collection { post :import }
  end
  
  resources :navigations do
    collection { post :import }
  end
  
  resources :accounts do
    collection { post :import }
  end
  
  resources :finance_states do
    collection { post :import }
    collection { post :synchronize }
    collection { post :delete_all }
  end
  
  resources :monthly_statistics do
    collection { post :import }
    collection { post :delete_all }
  end
    
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
