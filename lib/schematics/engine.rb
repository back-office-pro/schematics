# frozen_string_literal: true

require 'json'
require 'csv'
require 'pagy'
require 'paranoia'
require 'paper_trail'
require 'rails'
require 'action_controller'
require 'binding_of_caller'
require 'elasticsearch'
require 'searchkick'
require 'rack/attack'
require 'rack/cors'
require 'simple_form'
require 'client_side_validations'
require 'client_side_validations/simple_form'
require 'slim'
require 'rails-i18n'
require 'friendly_id'
require 'phonelib'
require 'valid_email'
require 'validate_url'
require 'active_storage_validations'
require 'ruby-vips'
require 'active_link_to'
require 'loaf'
require 'groupdate'
require 'chartkick'
require 'active_storage_base64'
require 'route_translator'
require 'easy_translate'
require 'active_model_serializers'
require 'interactor'
require 'cancancan'
require 'country_select'
require 'view_component'
require 'ratonvirus'
require 'ratonvirus/clamby'
require 'i18n/beginning_of_week'
require 'redis'
require 'hiredis'
require 'rack-mini-profiler'
require 'aasm'
require 'strip_attributes'
require 'i18n-inflector'
require 'chroma'
require 'sprockets/railtie'
require 'importmap-rails'
require 'turbo-rails'
require 'stimulus-rails'
require 'rollbar'
require 'activejob/uniqueness'
require 'link_thumbnailer'
require 'rqrcode'
require 'icalendar'
require 'dry/transformer'
require 'git'
require 'terser'
require 'sassc-rails'
require 'dotenv-rails'
require 'dry-initializer'

module Schematics
  class Engine < ::Rails::Engine
    isolate_namespace Schematics

    class << self
      def default_url_options
        return { host: 'back-office.pro' } if Rails.env.production?

        { host: 'localhost', port: 3000 }
      end

      def join_config(*pathnames)
        root.join(*pathnames.unshift('config'))
      end

      def credentials = ActiveSupport::EncryptedConfiguration.new(
        config_path: join_config('credentials.yml.enc'),
        key_path: join_config('master.key'),
        env_key: 'SCHEMATICS_MASTER_KEY',
        raise_if_missing_key: true
      )
    end

    # Generators
    config.app_generators do |generator|
      generator.orm :active_record, primary_key_type: :uuid
      generator.templates.unshift root.join('lib', 'templates')
      generator.test_framework :rspec
      generator.integration_tool :rspec
      generator.assets false
      generator.helper false
      generator.template_engine nil
      generator.jbuilder nil
    end

    # Security
    config.force_ssl = Rails.env.production?
    config.require_master_key = true

    # Logs
    config.log_file_size = 100.megabytes # TODO: enabled when upgrading to Rails 7.1

    # Action Controller
    config.action_controller.action_on_unpermitted_parameters = :raise if Rails.env.development?
    config.action_controller.default_url_options = default_url_options

    # Action Dispatch
    config.action_dispatch.signed_cookie_digest = 'SHA256'
    config.action_dispatch.rescue_responses['ActiveRecord::PendingMigrationError'] = :service_unavailable # rubocop:disable Layout/LineLength

    # Active Record
    config.active_record.async_query_executor = :global_thread_pool
    config.active_record.strict_loading_by_default = true
    config.active_record.query_log_tags_enabled = true
    config.active_record.action_on_strict_loading_violation = :log
    config.active_record.warn_on_records_fetched_greater_than = 100
    config.active_record.encryption.support_unencrypted_data = true
    config.active_record.encryption.extend_queries = true

    # Active Job
    config.active_job.queue_adapter = Rails.env.test? ? :test : :sidekiq

    # Mailer
    config.action_mailer.delivery_method = :sendmail
    config.action_mailer.default_url_options = default_url_options
    config.action_mailer.default_options = { from: 'localhost' }
    config.action_mailer.preview_path = root.join('spec', 'mailers', 'previews')
    config.action_mailer.raise_delivery_errors = Rails.env.development?

    # Assets
    config.assets.paths << ::Pagy.root.join('javascripts')
    config.assets.paths << root.join('app', 'components', 'schematics')
    config.assets.precompile += %w[schematics_manifest.js]
    config.assets.js_compressor  = :terser if Rails.env.production?
    config.assets.css_compressor = :sass if Rails.env.production?

    # Importmap
    config.importmap.paths << join_config('importmap.rb')

    # i18n
    config.i18n.default_locale = Rails.env.test? ? :en : :fr
    config.i18n.available_locales = %i[fr en]
    config.i18n.raise_on_missing_translations = !Rails.env.production?

    # Theme
    config.theme_color = '#2c3e50'

    # Production
    config.before_configuration do |app|
      # Cache
      app.config.cache_store = :redis_cache_store, ::Tenant.redis_options
    end

    # Make sure we override main app defaults
    config.after_initialize do |app|
      # Active Storage
      config.active_storage.service = :amazon if Rails.env.production?
      config.active_storage.replace_on_assign_to_many = false
      # Time zone
      app.config.time_zone = 'Paris'
    end
  end
end
