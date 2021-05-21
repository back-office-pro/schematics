# frozen_string_literal: true

Rails.application.routes.default_url_options = Rails.application.config.action_mailer.default_url_options # rubocop:disable Layout/LineLength
Rails.application.routes.prepend do
  mount Schematics::Engine, at: '/'
  mount GrapeSwaggerRails::Engine, at: '/api', constraints: Schematics::AuthConstraint
  localized do
    Schematics::Schema.instance.load_routes
  end
end
