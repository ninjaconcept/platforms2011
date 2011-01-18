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
  
  scope "/ws", :contraints => { :format => 'json' } do
    resources :conferences, :only => [:create, :show, :update] do
      resources :attendees, :only => [:create, :list, :delete]
    end
    resources :members, :only => [:create, :show, :update] do
      resources :contacts, :only => [:create, :list] 
    end
    resources :categories, :only => [:list, :create]
    resources :series, :only => [:list, :create, :show]
    match "/conferencesbycategory/:id" => "categories#by_id"
    match "/search/:query" => "search#search"
    match "/reset" => "DataController#reset"
    match "/factorydefaults" => "DataController#factory_defaults"
  end

end
