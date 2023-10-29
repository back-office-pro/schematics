# frozen_string_literal: true

get '/service_worker.js', to: 'pwa#service_worker', as: :service_worker
get '/manifest.json', to: 'pwa#manifest', as: :manifest
