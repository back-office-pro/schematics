# frozen_string_literal: true

OpenAI.configure do |config|
  config.access_token = Schematics::Engine.credentials.openai[:access_token]
  config.log_errors = true
  config.request_timeout = 30
end
