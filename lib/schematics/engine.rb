# frozen_string_literal: true

module Schematics
  class Engine < ::Rails::Engine
    isolate_namespace Schematics

    # Generators
    config.app_generators do |generator|
      generator.orm :active_record, primary_key_type: :uuid
      generator.templates.unshift root.join('lib', 'templates')
      generator.assets false
      generator.helper false
      generator.template_engine nil
      generator.jbuilder nil
    end

    # Security
    config.force_ssl = Rails.env.production?
    config.require_master_key = true

    # Action Controller
    config.action_controller.action_on_unpermitted_parameters = :raise if Rails.env.development?

    # Active Record
    config.active_record.strict_loading_by_default = true
    config.active_record.action_on_strict_loading_violation = :log # unless Rails.env.development?
    config.active_record.warn_on_records_fetched_greater_than = 100

    # Active Job
    config.active_job.queue_adapter = :sidekiq

    # Mailer
    config.action_mailer.delivery_method = :sendmail
    config.action_mailer.default_url_options = { host: 'localhost', port: 3000 }
    config.action_mailer.default_options = { from: 'localhost' }
    config.action_mailer.preview_path = root.join('spec', 'mailers', 'previews')

    # Assets
    config.assets.paths << Pagy.root.join('javascripts')
    config.assets.paths << root.join('app', 'components', 'schematics')
    config.assets.precompile += %w[schematics_manifest.js]

    # i18n
    config.i18n.default_locale = :fr
    config.i18n.available_locales = %i[fr en]
    config.i18n.load_path += Dir[root.join('config', 'locales', '**', '*.yml')]
    config.i18n.raise_on_missing_translations = !Rails.env.production?

    # Active Storage
    config.after_initialize do # Make sure we override main app 6.0 defaults
      config.active_storage.replace_on_assign_to_many = false
    end

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
