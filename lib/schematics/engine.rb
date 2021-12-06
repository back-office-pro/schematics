# frozen_string_literal: true

require 'json'
require 'csv'
require 'pagy'
require 'paranoia'
require 'paper_trail'
require 'rails'
require 'action_controller'
require 'binding_of_caller'
require 'searchkick'
require 'rack/attack'
require 'rack/cors'
require 'simple_form'
require 'client_side_validations'
require 'client_side_validations/simple_form'
require 'wicked_pdf'
require 'slim'
require 'rails-i18n'
require 'font_awesome5_rails'
require 'friendly_id'
require 'phonelib'
require 'valid_email'
require 'validate_url'
require 'active_storage_validations'
require 'mini_magick'
require 'active_link_to'
require 'loaf'
require 'groupdate'
require 'chartkick'
require 'humanize'
require 'active_storage_base64'
require 'route_translator'
require 'date_validator'
require 'google/cloud/translate'
require 'active_model_serializers'
require 'acts_as_singleton'
require 'title'
require 'best_in_place'
require 'rails-erd'
require 'bootstrap-email'
require 'interactor'
require 'rails-timeago'
require 'cancancan'
require 'rspec_api_documentation'
require 'grape-swagger-rails'
require 'sweet-alert2-rails'
require 'country_select'
require 'view_component'
require 'ratonvirus'
require 'ratonvirus/clamby'
require 'i18n/beginning_of_week'
require 'redis'
require 'hiredis'
require 'rack-mini-profiler'
require 'draper'
require 'aasm'

module Schematics
  class Engine < ::Rails::Engine
    isolate_namespace Schematics

    # Generators
    config.app_generators do |generator|
      generator.orm :active_record, primary_key_type: :uuid
      generator.templates.unshift root.join('lib', 'templates')
      generator.assets false
      generator.helper false
      generator.decorator false
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

    # Cache
    config.cache_store = :redis_cache_store, { url: ENV['REDIS_URL'] } if Rails.env.production?

    # Active Storage
    config.after_initialize do # Make sure we override main app 6.1 defaults
      config.active_storage.replace_on_assign_to_many = false
      config.active_storage.track_variants = false
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
