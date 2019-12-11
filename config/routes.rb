Schematics::Engine.routes.draw do
  root 'dashboard#home'
  get 'search',   to: 'dashboard#search',   as: :search
  get 'timeline', to: 'dashboard#timeline', as: :timeline
  resources :files, except: [:index, :show]
end
