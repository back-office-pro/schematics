# frozen_string_literal: true

require 'active_support/core_ext/integer/time'

Rails.application.configure do
  # Configuration
  config.cache_classes = false
  config.consider_all_requests_local = true
  config.eager_load = false
  config.server_timing = true

  # Public File Server
  config.public_file_server.enabled = true
  config.public_file_server.headers = { 'Cache-Control' => "public, max-age=#{2.days.to_i}" } # rubocop:disable Style/StringHashKeys

  # Active Job
  config.active_job.queue_adapter = Tenant.backend.queue_adapter

  # Active Storage
  config.active_storage.service = :local

  # Mailer
  config.action_mailer.raise_delivery_errors = true
  config.action_mailer.perform_caching = false
  config.action_mailer.delivery_method = :sendmail

  # Active Support
  config.active_support.deprecation = :log
  config.active_support.disallowed_deprecation = :raise
  config.active_support.disallowed_deprecation_warnings = []

  # Active Record
  config.active_record.migration_error = :page_load
  config.active_record.verbose_query_logs = true

  # Action Controller
  config.action_controller.action_on_unpermitted_parameters = :raise
  config.action_controller.perform_caching = true
  config.action_controller.enable_fragment_cache_logging = true

  # i18n
  config.i18n.raise_on_missing_translations = true

  # Action View
  config.action_view.annotate_rendered_view_with_filenames = true

  # Assets
  config.assets.quiet = true

  # Cache
  config.cache_store = Tenant.backend.cache_store, Tenant.backend.cache_store_options
end
