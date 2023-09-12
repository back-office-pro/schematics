# frozen_string_literal: true

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :google_oauth2,
           Schematics::Engine.credentials.google_oauth2[:client_id],
           Schematics::Engine.credentials.google_oauth2[:client_secret],
           { prompt: 'select_account' }
end
