# frozen_string_literal: true

get 'open_api.json', to: 'swagger#show', as: :open_api
get :api, to: 'swagger#index', as: :api
