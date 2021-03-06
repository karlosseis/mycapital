Rails.application.routes.draw do

  resources :exchange_rates
  resources :brokers
  resources :mapconcepts
  resources :movements
  resources :locations
  resources :estimated_movements
  resources :movementtypes
  resources :planif_records
  resources :periodicities
  resources :subcategories
  resources :categories
  get 'configuration_page/index'

  get 'excel_import/index'

  resources :company_historic_dividends
  get 'targets/index'
  get 'welcome/sindiv'
  get 'welcome/exchange_rates'


resources :excel_import do
  collection do
    post :import_historic_dividend
    post :import_categories
    post :import_subcategories
    post :import_planif_records
    post :import_locations
    post :import_mapconcepts
    post :import_movements
  end
end
  

  resources :company_results
  resources :company_comments
  resources :reference_webs
  resources :expert_target_prices
  resources :balance_details
  resources :balances
  resources :accounts
  resources :banks
  get 'background_actions/create_company'

  get 'background_action/create_company'

  get 'dashboard/index'

  resources :expected_dividends
  resources :companies do
    resources :operations
    resources :expert_target_prices
    resources :company_comments
    resources :company_results
    resources :company_historic_dividends
  end
  resources :stockexchanges
  resources :sectors
  resources :operationtypes
  resources :currencies
  resources :countries
  devise_for :users
  resources :yahoo_tickers #, :only => [:index, :new]
  
  
  post 'create_company' => 'yahoo_tickers#create_company', as: :create_company

  resources :operations  #, :only => [:index, :delete]

  resources :dashboards

  get 'portfolio', to: 'companies#portfolio'
  #get 'index_historic_dividend', to: 'dashboard#index_historic_dividend'
  get 'index_expect_real_dividend_month', to: 'dashboard#index_expect_real_dividend_month'
  get 'index_estimated_movements', to: 'dashboard#index_estimated_movements'


  get 'index_sales_year', to: 'dashboard#index_sales_year'
  get 'index_purchases_year', to: 'dashboard#index_purchases_year'

  get 'welcome/index'

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
