Cmsimple::Engine.routes.draw do

  match '/cmsimple/snippets/:name/preview' => 'snippets#preview'
  match '/cmsimple/snippets/:name/options' => 'snippets#options'
  match '/cmsimple/snippets' => 'snippets#index', :as => :snippets

  resources :pages, :only => [:index, :edit, :update]

  match '/mercury/:type/:resource' => "mercury#resource"

  match '/editor(/*page)' => "pages#editor", :as => :mercury_editor

  match '*page' => 'pages#show', :via => :get
  root :to => 'pages#show', :via => :get

  match '*page' => 'pages#update_content', :via => :post
  root :to => 'pages#update_content', :via => :post

end
