# frozen_string_literal: true

Rails.application.reload_routes!
GrapeSwaggerRails.options.url = Schematics::Engine.routes.url_helpers.swagger_open_api_path
GrapeSwaggerRails.options.app_url = 'http://localhost:3000'
GrapeSwaggerRails.options.doc_expansion = 'list'
GrapeSwaggerRails.options.hide_url_input = true
GrapeSwaggerRails.options.hide_api_key_input = true
GrapeSwaggerRails.options.api_auth = 'basic'
GrapeSwaggerRails.options.api_key_name = 'Authorization'
GrapeSwaggerRails.options.api_key_type = 'header'
GrapeSwaggerRails.options.app_name = "#{Rails.application.class.module_parent_name} API documentation" # rubocop:disable Layout/LineLength
