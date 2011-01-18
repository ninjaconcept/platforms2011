PlatForms::Application.routes.draw do
  
  resources :member_of_series

  resources :series

  resources :categories

  resources :conferences

  resources :pages
  
  match '/auth/:provider/callback', :to => 'authentications#create'
  resources :authentications
 
  namespace :admin do
    resources :authentications
  end
  
  devise_for :users, :controllers => { :registrations => 'registrations' }

  root :to => "pages#index"
  
  scope "/ws", :contraints => { :format => :json }, :defaults => {:format => :json} do
    resources :conferences, :only => [:create, :show, :update] do
      resources :attendees, :only => [:create, :index, :destroy]
    end
    resources :members, :only => [:create, :show, :update] do
      resources :contacts, :only => [:create, :index] 
    end
    resources :categories, :only => [:index, :create]
    resources :series, :only => [:indes, :create, :show]
    match "/conferencesbycategory/:id" => "Categories#by_id"
    match "/search/:query" => "Search#search"
    match "/reset" => "DataController#reset"
    match "/factorydefaults" => "DataController#factory_defaults"
  end

end
