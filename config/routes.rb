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
  get '/get_pie_data', to: 'monthly_statistics#get_pie_data'
  get '/get_salaries', to: 'monthly_statistics#get_salaries'
  get '/get_date_of_last_income', to: 'monthly_statistics#get_date_of_last_income'
  get '/get_date_of_first_income', to: 'monthly_statistics#get_date_of_first_income'
   
  #get '/delete_all', to: 'monthly_statistics#delete_all'
  get '/get_item', to: 'items#get_item'
  get '/get_expenses_grouped', to: 'dashboard#get_expenses_grouped'
  
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
