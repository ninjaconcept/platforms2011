PlatForms::Application.routes.draw do
  
  resources :member_of_series

  resources :series

  resources :categories

  resources :conferences do
    collection do
      get 'search'
    end
    match "attendances/:username" => "attendances#destroy", :via => :delete, :as=>:attendances_delete
  end
  get "conferences/:id/ical" => "conferences#ical", :as=>:conference_ical
  
  resources :members, :only => [:show, :index] do
    collection do
      get 'search'
    end
  end

  resources :pages

  resources :notifications

  match '/status/', :to => 'status#index'

  match '/auth/:provider/callback', :to => 'authentications#create'
  resources :authentications

  resources :contacts do
    collection do
      post "add" => "contacts#add", :as=> :add
    end
  end

  namespace :admin do
    resources :users
    resources :authentications
    
    resources :series, :except => :show
    resources :conferences
    resources :categories do
      resources :conferences
    end  
  end
  
  devise_for :users, :controllers => { :registrations => 'registrations' }
  match '/status' => 'status#index', :as => 'user_root'

  root :to => "categories#index"
  
  scope "/ws", :contraints => { :format => :json }, :defaults => {:format => :json} do
    resources :conferences, :only => [:create, :show, :update] do
      resources :attendances, :only => [:create, :index]
      match "attendances/:username" => "attendances#destroy", :via => :delete
    end
    
    match "/members" => "members#create", :via => :post
    match "/members/:uname" => "members#show", :via => :get
    match "/members/:uname" => "members#update", :via => :put
    match "/members/:uname/contacts" => "contacts#index", :via => :get
    match "/members/:uname/contacts" => "contacts#add", :via => :post
    
    resources :categories, :only => [:index, :show, :create]
    resources :series, :only => [:indes, :create, :show]
    match "/conferencesbycategory/:id" => "Categories#by_id"
    match "/search/:search_term" => "conferences#search"
    match "/reset" => "DataController#reset"
    match "/factorydefaults" => "DataController#factory_defaults"
  end

end
