# frozen_string_literal: true

Rails.application.reload_routes!
GrapeSwaggerRails.options.tap do |config|
  config.url = Schematics::Engine.routes.url_helpers.swagger_open_api_path
  config.app_url = 'http://localhost:3000'
  config.doc_expansion = 'list'
  config.hide_url_input = true
  config.hide_api_key_input = true
  config.api_auth = 'basic'
  config.api_key_name = 'Authorization'
  config.api_key_type = 'header'
  config.app_name = "#{Rails.application.class.module_parent_name} API documentation"
end
