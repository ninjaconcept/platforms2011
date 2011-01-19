PlatForms::Application.routes.draw do
  
  resources :member_of_series

  resources :series

  resources :categories

  resources :conferences do
    collection do
        get 'search'
      end
    # match "/search" => "Conferences#search", :as => :search
  end

  resources :pages
  
  match '/auth/:provider/callback', :to => 'authentications#create'
  resources :authentications
 
  namespace :admin do
    resources :users
    resources :authentications
    
    resources :conferences
    resources :categories do
      resources :conferences
    end  
  end
  
  devise_for :users, :controllers => { :registrations => 'registrations' }

  root :to => "categories#index"
  
  scope "/ws", :contraints => { :format => :json }, :defaults => {:format => :json} do
    resources :conferences, :only => [:create, :show, :update] do
      resources :attendances, :only => [:create, :index]
      match "attendances/:username" => "attendances#destroy", :via => :delete
    end
    
    match "/members" => "members#create", :via => :post
    match "/members/:username" => "members#show", :via => :get
    match "/members/:username" => "members#update", :via => :put
    match "/members/:username/contacts" => "contacts#index", :via => :get
    match "/members/:username/contacts" => "contacts#add", :via => :post
    
    resources :categories, :only => [:index, :create]
    resources :series, :only => [:indes, :create, :show]
    match "/conferencesbycategory/:id" => "Categories#by_id"
    match "/search/:query" => "Search#search"
    match "/reset" => "DataController#reset"
    match "/factorydefaults" => "DataController#factory_defaults"
  end

end
