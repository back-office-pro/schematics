# frozen_string_literal: true

Rails.configuration.exceptions_app = Rails.application.routes

Rails.application.routes.prepend do
  direct(:website) { Server.url }
  mount Schematics::Engine, at: '/'
  mount MissionControl::Jobs::Engine, at: '/internal/jobs'
  localized do
    get 'auth/:provider/callback', to: 'sessions#create', as: :omniauth_login
    get 'up', to: 'rails/health#show', as: :health_check
    get 'service-worker', to: 'rails/pwa#service_worker', as: :pwa_service_worker
    get 'manifest', to: 'rails/pwa#manifest', as: :pwa_manifest
    get 'login', to: 'sessions#new', as: :login
    get '/:resource', to: 'schematics/routing#index', as: :route_resources
    get '/:resource/new', to: 'schematics/routing#new'
    post '/:resource', to: 'schematics/routing#create'
    get '/:resource/:id', to: 'schematics/routing#show', as: :route_resource
    get '/:resource/:id/edit', to: 'schematics/routing#edit', action: :edit
    patch '/:resource/:id', to: 'schematics/routing#update'
    put '/:resource/:id', to: 'schematics/routing#update'
    delete '/:resource/:id', to: 'schematics/routing#destroy'
    delete '/:resource/:id/archive', to: 'schematics/routing#archive'
    delete '/:resource/:id/restore', to: 'schematics/routing#restore'
    post '/:resource/:id/duplicate', to: 'schematics/routing#duplicate'
    get '/:resource/:id', to: 'schematics/routing#delete'
    get '/:resource/imports/new', to: 'imports_controller#new'
    post '/:resource/imports', to: 'imports_controller#create'
    post '/:resource/comparisons', to: 'comparisons_controller#create'
    post '/:resource/bulk_actions', to: 'schematics/bulk_actions#create'
    post '/:resource/autocompletions', to: 'schematics/autocompletions#create'
    get '/:resource/:id/comments/new', to: 'comments_controller#new'
    get '/:resource/:id/emailings/new', to: 'emailings_controller#new'
    post '/:resource/:id/comments', to: 'comments_controller#create'
    post '/:resource/:id/emailings', to: 'emailings_controller#create'
    patch '/:resource/:id/:state/:event', to: 'schematics/routing#trigger'
  end
end
