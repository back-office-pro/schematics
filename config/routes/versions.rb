get 'versions/preferences', to: 'versions#preferences', as: :notification_preferences

resources :versions, only: %i[index show] do
  member do
    get :revert
  end
end
