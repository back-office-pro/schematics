# frozen_string_literal: true

require 'aasm'
require 'action_controller'
require 'active_link_to'
require 'active_model_serializers'
require 'active_storage_base64'
require 'active_storage_validations'
require 'activejob/uniqueness'
require 'binding_of_caller'
require 'bootstrap_form'
require 'cancancan'
require 'chartkick'
require 'chroma'
require 'country_select'
require 'csv'
require 'dotenv-rails'
require 'dry-initializer'
require 'dry/transformer'
require 'easy_translate'
require 'elasticsearch'
require 'friendly_id'
require 'git'
require 'good_job'
require 'groupdate'
require 'hiredis'
require 'i18n-inflector'
require 'i18n/beginning_of_week'
require 'icalendar'
require 'importmap-rails'
require 'interactor'
require 'json'
require 'link_thumbnailer'
require 'loaf'
require 'pagy'
require 'paper_trail'
require 'paranoia'
require 'phonelib'
require 'rack-mini-profiler'
require 'rack/attack'
require 'rack/cors'
require 'rails'
require 'rails-i18n'
require 'ratonvirus'
require 'ratonvirus/clamby'
require 'redis'
require 'rollbar'
require 'route_translator'
require 'rqrcode'
require 'ruby-graphviz'
require 'ruby-vips'
require 'sassc-rails'
require 'searchkick'
require 'simple_form'
require 'slim'
require 'sprockets/railtie'
require 'stimulus-rails'
require 'strip_attributes'
require 'terser'
require 'turbo-rails'
require 'valid_email'
require 'validate_url'
require 'view_component'

module Schematics
  class Engine < ::Rails::Engine
    isolate_namespace Schematics

    class << self
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
    config.active_job.queue_adapter = ::Tenant.storage.queue_adapter

    # Good job
    config.good_job.execution_mode = :async
    config.good_job.enable_cron = true
    config.good_job.cron = YAML.load_file(join_config('sidekiq.yml')).fetch(:schedule)

    # Mailer
    config.action_mailer.delivery_method = :sendmail
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
    config.i18n.default_locale = :en
    config.i18n.available_locales = %i[en fr]
    config.i18n.raise_on_missing_translations = !Rails.env.production?

    # Make sure we override main app defaults
    config.after_initialize do
      # Active Storage
      config.active_storage.service = :amazon if Rails.env.production?
      config.active_storage.replace_on_assign_to_many = false
    end
  end
end
