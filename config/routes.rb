Cmsimple::Engine.routes.draw do

  # Mercury::Engine.routes

  match '*page' => 'pages#show', :via => :get
  root :to => 'pages#show', :via => :get

  match '*page' => 'pages#update_content', :via => :post
  root :to => 'pages#update_content', :via => :post
end
