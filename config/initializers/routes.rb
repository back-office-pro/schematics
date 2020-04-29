Rails.application.routes.default_url_options =
  Rails.application.config.action_mailer.default_url_options

Rails.application.routes.append do
  mount Schematics::Engine, at: "/"
  mount SwaggerUiEngine::Engine, at: "/api"
end
