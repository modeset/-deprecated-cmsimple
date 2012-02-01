Cmsimple::Engine.routes.draw do
  match '*page' => 'cmsimple/pages#show'
  root :to => 'cmsimple/pages#show'
end
