Cmsimple::Engine.routes.draw do

  match '/cmsimple/snippets/:name/preview' => 'snippets#preview'
  match '/cmsimple/snippets/:name/options' => 'snippets#options'
  match '/cmsimple/snippets' => 'snippets#index', :as => :snippets

  resources :pages do
    member do
      get :publish
    end
    resources :versions, :only => [:index] do
      member do
        put :revert_to
      end
    end
  end

  resources :paths, :only => [:index, :create, :destroy]

  scope '/cmsimple' do
    resources :images
  end

  get '/mercury/:type/:resource' => "mercury#resource"

  get '/editor(/*path)' => "pages#editor", :as => :mercury_editor, :format => false

  get '*path' => 'front#show', :format => false
  root :to => 'front#show', :via => :get

  put '*path' => 'pages#update_content'
  root :to => 'pages#update_content', :via => :put

end
