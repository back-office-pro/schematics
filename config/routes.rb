Schematics::Engine.routes.draw do
  get 'search',   to: 'search#query',   as: :search
  get 'timeline', to: 'timeline#index', as: :timeline
  resources :files, except: [:index, :show]
end
