Cmsimple::Engine.routes.draw do

  match '/cmsimple/snippets/:name/preview' => 'snippets#preview'
  match '/cmsimple/snippets/:name/options' => 'snippets#options'
  match '/cmsimple/snippets' => 'snippets#index', :as => :snippets

  resources :pages do
    member do
      get :publish
    end
  end

  resources :paths, :only => [:index, :create, :destroy]

  scope '/cmsimple' do
    resources :images
  end

  match '/mercury/:type/:resource' => "mercury#resource"

  match '/editor(/*page)' => "pages#editor", :as => :mercury_editor

  match '*page' => 'pages#show', :via => :get
  root :to => 'pages#show', :via => :get

  match '*page' => 'pages#update_content', :via => :post
  root :to => 'pages#update_content', :via => :post

end
