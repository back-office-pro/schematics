module Schematics
  class Engine < ::Rails::Engine
    isolate_namespace Schematics

    config.app_generators do |g|
      g.orm :active_record, primary_key_type: :uuid
      g.templates.unshift(File.expand_path('../templates', __dir__))
      g.assets          false
      g.template_engine false
      g.helper          false
      g.jbuilder        false
    end

    # Mailer
    config.action_mailer.delivery_method = :sendmail
    config.action_mailer.default_url_options = { host: "localhost", port: 3000 }
    config.action_mailer.default_options = { from: "no-reply@example.com" }
    config.action_mailer.preview_path = Schematics::Engine.root.join("spec", "mailers", "previews")

    # i18n
    config.i18n.default_locale = :fr
    config.i18n.available_locales = [:fr, :en]
    config.i18n.load_path += Dir.glob(File.expand_path('../../config/locales/**/*.yml', __dir__))
  end
end
