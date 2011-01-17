PlatForms::Application.routes.draw do
  
  resources :pages
  
  match '/auth/:provider/callback', :to => 'authentications#create'
  resources :authentications
 
  namespace :admin do
    resources :authentications
  end
  
  devise_for :users, :controllers => { :registrations => 'registrations' }

  root :to => "pages#index"

end
