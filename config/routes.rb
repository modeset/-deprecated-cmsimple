Cmsimple::Engine.routes.draw do

  # Mercury::Engine.routes

  match '*page' => 'pages#show', :via => :get
  root :to => 'pages#show', :via => :get

  match '*page' => 'pages#update', :via => :post
  root :to => 'pages#update', :via => :post
end
