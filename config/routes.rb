Cmsimple::Engine.routes.draw do
  match '*page' => 'pages#show'
  root :to => 'pages#show'
end
