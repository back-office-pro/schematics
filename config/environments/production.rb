# frozen_string_literal: true

require 'active_support/core_ext/integer/time'

Rails.application.configure do
  # Configuration
  config.cache_classes = true
  config.consider_all_requests_local = false
  config.eager_load = true

  # Security
  config.force_ssl = true
  config.require_master_key = true

  # Assets
  config.assets.compile = false
  config.assets.js_compressor  = :terser
  config.assets.css_compressor = :sass

  # Action Controller
  config.action_controller.perform_caching = true

  # Public File Server
  config.public_file_server.enabled = ENV['RAILS_SERVE_STATIC_FILES'].present?

  # Active Storage
  config.active_storage.service = :amazon

  # Active Job
  config.active_job.queue_adapter = Tenant.backend.queue_adapter
  config.active_job.queue_name_prefix = Tenant.database_name

  # Cache
  config.cache_store = Tenant.backend.cache_store, Tenant.backend.cache_store_options

  # Mailer
  config.action_mailer.perform_caching = false
  config.action_mailer.raise_delivery_errors = false
  config.action_mailer.delivery_method = :sendmail

  # i18n
  config.i18n.fallbacks = true

  # Active Support
  config.active_support.report_deprecations = false

  # Active Record
  config.active_record.dump_schema_after_migration = false

  # Logger
  config.log_level = :info
  config.log_tags = [:request_id]
  config.log_formatter = Logger::Formatter.new

  if ENV['RAILS_LOG_TO_STDOUT'].present?
    logger = ActiveSupport::Logger.new($stdout)
    logger.formatter = config.log_formatter
    config.logger = ActiveSupport::TaggedLogging.new(logger)
  end
end
