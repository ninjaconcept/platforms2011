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

end
