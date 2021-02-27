module Schematics
  class Engine < ::Rails::Engine
    isolate_namespace Schematics

    # Generators
    config.app_generators do |g|
      g.orm :active_record, primary_key_type: :uuid
      g.templates.unshift(File.expand_path('../templates', __dir__))
      g.assets          false
      g.helper          false
      g.template_engine nil
      g.jbuilder        nil
    end

    # Active Record
    config.active_record.strict_loading_by_default = true
    config.active_record.action_on_strict_loading_violation = :log # if Rails.env.production?

    # Mailer
    config.action_mailer.delivery_method = :sendmail
    config.action_mailer.default_url_options = { host: 'localhost', port: 3000 }
    config.action_mailer.default_options = { from: 'localhost' }
    config.action_mailer.preview_path = root.join('spec', 'mailers', 'previews')

    # i18n
    config.i18n.default_locale = :fr
    config.i18n.available_locales = %i[fr en]
    config.i18n.load_path += Dir.glob(File.expand_path('../../config/locales/**/*.yml', __dir__))

    def credentials
      ActiveSupport::EncryptedConfiguration.new(
        config_path: root.join('config', 'credentials.yml.enc'),
        key_path: root.join('config', 'master.key'),
        env_key: 'RAILS_MASTER_KEY',
        raise_if_missing_key: true
      )
    end
  end
end
