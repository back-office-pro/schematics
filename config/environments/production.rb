# frozen_string_literal: true

require 'active_support/core_ext/integer/time'

Rails.application.configure do
  # Configuration
  config.enable_reloading = false
  config.consider_all_requests_local = false
  config.eager_load = true

  # Security
  config.assume_ssl = Tenant.ssl?
  config.force_ssl = Tenant.ssl?
  config.hosts = [Tenant.host] if Tenant.ssl?
  config.require_master_key = true

  # Assets
  config.assets.compile = false
  config.assets.js_compressor  = :terser
  config.assets.css_compressor = :sass

  # Action Controller
  config.action_controller.perform_caching = true

  # Public File Server
  config.public_file_server.enabled = true
  config.public_file_server.headers = { 'Cache-Control' => "public, max-age=#{1.year.to_i}" } # rubocop:disable Style/StringHashKeys

  # Active Storage
  config.active_storage.service = :amazon

  # Active Job
  config.active_job.queue_adapter = Tenant.backend.queue_adapter

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
  config.lograge.enabled = true
  config.logger = ActiveSupport::Logger
                  .new($stdout)
                  .tap  { |logger| logger.formatter = Logger::Formatter.new }
                  .then { |logger| ActiveSupport::TaggedLogging.new(logger) }
end
