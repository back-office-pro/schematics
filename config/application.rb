# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

require_relative 'boot'

require 'rails/all'

Bundler.require(*Rails.groups)

module BackOffice
  class Application < Rails::Application
    config.load_defaults 8.0
    config.autoload_lib(ignore: %w[assets tasks])

    # Generators
    config.app_generators do |generator|
      generator.orm :active_record, primary_key_type: :string
      generator.templates.unshift root.join('lib', 'templates')
      generator.test_framework nil
      generator.resource_route false
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
    config.log_file_size = 100.megabytes

    # Action Dispatch
    config.action_dispatch.signed_cookie_digest = 'SHA256'

    # Active Record
    config.active_record.enumerate_columns_in_select_statements = true
    config.active_record.async_query_executor = :global_thread_pool
    config.active_record.strict_loading_by_default = true
    config.active_record.query_log_tags_enabled = true
    config.active_record.migration_error = false
    config.active_record.action_on_strict_loading_violation = :log
    config.active_record.encryption.support_unencrypted_data = true
    config.active_record.encryption.extend_queries = true
    config.active_record.queues.destroy = :low

    # Active Record Encryption
    if credentials.active_record_encryption
      config.active_record.encryption.primary_key = credentials.active_record_encryption.primary_key
      config.active_record.encryption.deterministic_key = credentials.active_record_encryption.deterministic_key # rubocop:disable Layout/LineLength
      config.active_record.encryption.key_derivation_salt = credentials.active_record_encryption.key_derivation_salt # rubocop:disable Layout/LineLength
    end

    # Mailer
    config.action_mailer.preview_paths << root.join('spec', 'mailers', 'previews')
    config.action_mailer.smtp_settings = { open_timeout: 1, read_timeout: 1 }

    # Assets
    config.assets.version = '1.0.0'
    config.assets.paths << ::Pagy.root.join('javascripts')
    config.assets.paths << root.join('app', 'components', 'schematics')
    config.assets.paths << root.join('node_modules')

    # Importmap
    config.importmap.paths << root.join('config', 'importmap.rb')
    config.importmap.cache_sweepers << root.join('app', 'assets', 'javascripts')

    # i18n
    config.i18n.default_locale = :en
    config.i18n.available_locales = %i[en fr it]
    config.i18n.fallbacks = true

    # Solid Cache
    config.solid_cache.encrypt = true

    # MissionControl
    config.mission_control.jobs.base_controller_class = 'Schematics::BasicAuthenticationController'
    config.mission_control.jobs.http_basic_auth_enabled = false
    config.mission_control.jobs.show_console_help = false

    # ViewComponent
    config.view_component.capture_compatibility_patch_enabled = true
    config.view_component.test_controller = 'Schematics::ApplicationController'
    config.view_component.show_previews = false

    # Active Storage
    config.after_initialize do
      config.active_storage.queues.purge = :low
      config.active_storage.track_variants = false
    end
  end
end
