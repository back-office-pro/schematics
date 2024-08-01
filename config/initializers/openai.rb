# frozen_string_literal: true

OpenAI.configure do |config|
  config.access_token = Schematics::Engine.credentials.openai[:access_token]
  config.request_timeout = 60
  config.log_errors = true
end
