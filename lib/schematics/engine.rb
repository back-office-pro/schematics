# frozen_string_literal: true

require 'aasm'
require 'action_controller'
require 'active_link_to'
require 'active_storage_base64'
require 'active_storage_validations'
require 'bootstrap_form'
require 'cancancan'
require 'chartkick'
require 'chroma'
require 'csv'
require 'derailed_benchmarks'
require 'dotenv-rails'
require 'dry-initializer'
require 'dry/transformer'
require 'easy_translate'
require 'elasticsearch'
require 'enummer'
require 'ferrum'
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
require 'letter_opener'
require 'link_thumbnailer'
require 'loaf'
require 'lograge'
require 'mobility'
require 'mobility/ransack'
require 'pagy'
require 'paper_trail'
require 'paranoia'
require 'phonelib'
require 'puma'
require 'rack/attack'
require 'rack/cors'
require 'rails'
require 'rails-i18n'
require 'ransack'
require 'ransack-enum'
require 'ratonvirus'
require 'ratonvirus/clamby'
require 'redis'
require 'responders'
require 'rollbar'
require 'route_translator'
require 'rqrcode'
require 'ruby-graphviz'
require 'ruby-vips'
require 'sassc-rails'
require 'schematics/version'
require 'searchkick'
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
      def config_for(name)
        ActiveSupport::ConfigurationFile
          .parse(root.join('config', "#{name}.yml"))
          .deep_symbolize_keys
      end

      def credentials = ActiveSupport::EncryptedConfiguration.new(
        config_path: root.join('config', 'credentials.yml.enc'),
        key_path: root.join('config', 'master.key'),
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

    # Autoload
    config.autoload_paths += [
      root.join('app', 'models', 'core'),
      root.join('app', 'controllers', 'core')
    ]

    # Logs
    config.log_file_size = 100.megabytes # TODO: enabled when upgrading to Rails 7.1

    # Action Dispatch
    config.action_dispatch.signed_cookie_digest = 'SHA256'
    config.action_dispatch.rescue_responses['ActiveRecord::PendingMigrationError'] = :service_unavailable # rubocop:disable Layout/LineLength

    # Active Record
    config.active_record.enumerate_columns_in_select_statements = true
    config.active_record.async_query_executor = :global_thread_pool
    config.active_record.strict_loading_by_default = true
    config.active_record.query_log_tags_enabled = true
    config.active_record.action_on_strict_loading_violation = :log
    config.active_record.warn_on_records_fetched_greater_than = 100
    config.active_record.encryption.support_unencrypted_data = true
    config.active_record.encryption.extend_queries = true

    # Mailer
    config.action_mailer.preview_path = root.join('spec', 'mailers', 'previews')

    # Assets
    config.assets.version = VERSION
    config.assets.paths << ::Pagy.root.join('javascripts')
    config.assets.paths << root.join('app', 'components', 'schematics')
    config.assets.paths << root.join('node_modules')
    config.assets.precompile += %w[manifest.js schematics_manifest.js]

    # Importmap
    config.importmap.paths << root.join('config', 'importmap.rb')
    config.importmap.cache_sweepers << root.join('app', 'assets', 'javascripts')

    # i18n
    config.i18n.default_locale = :en
    config.i18n.available_locales = %i[en fr it]
    config.i18n.fallbacks = true

    # ViewComponent
    config.view_component.capture_compatibility_patch_enabled = true
    config.view_component.test_controller = 'Schematics::ApplicationController'

    # Responders
    config.responders.error_status = :unprocessable_entity
    config.responders.redirect_status = :see_other

    # Active Storage
    config.after_initialize do
      config.active_storage.track_variants = false
    end

    # Sprockets monkey-patch
    config.before_configuration do
      Sprockets::Railtie
        .instance
        .initializers
        .reject! { _1.name == :set_default_precompile }
    end
  end
end
