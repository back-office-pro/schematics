# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

require 'active_support/core_ext/integer/time'

Rails.application.configure do
  # Configuration
  config.enable_reloading = false
  config.consider_all_requests_local = false
  config.eager_load = true

  # Security
  config.assume_ssl = Server.ssl?
  config.force_ssl = Server.ssl?
  config.hosts = [Server.domain.dup.prepend('.')] if Server.ssl?
  config.sandbox_by_default = true
  config.require_master_key = true

  # Assets
  config.assets.compile = false
  config.assets.js_compressor = :terser

  # Action Controller
  config.action_controller.perform_caching = true

  # Public File Server
  config.public_file_server.enabled = true
  config.public_file_server.headers = { 'cache-control' => "public, max-age=#{1.year.to_i}" } # rubocop:disable Style/StringHashKeys

  # Active Storage
  config.active_storage.service = :local

  # Active Job
  config.active_job.queue_adapter = :solid_queue

  # Solid Cache
  config.solid_cache.connects_to = { database: { writing: :cache } }

  # Solid Queue
  config.solid_queue.connects_to = { database: { writing: :queue } }

  # Cache
  config.cache_store =
    :solid_cache_store,
    {
      active_record_instrumentation: false,
      expiry_method: :job,
      expiry_queue: :low,
      max_age: 2.weeks.to_i,
      max_entries: 2000,
      max_size: 1.gigabyte
    }

  # Mailer
  config.action_mailer.perform_caching = false
  config.action_mailer.raise_delivery_errors = false
  config.action_mailer.delivery_method = :sendmail

  # Active Support
  config.active_support.report_deprecations = false

  # Active Record
  config.active_record.dump_schema_after_migration = false
  config.active_record.attributes_for_inspect = %i[id]

  # Logger
  config.log_level = :info
  config.log_tags = [:request_id]
  config.lograge.enabled = true
  config.logger = ActiveSupport::TaggedLogging.logger($stdout)

  # Health check
  config.silence_healthcheck_path = '/up'
end
