# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

require 'active_support/core_ext/integer/time'

Rails.application.configure do
  # Configuration
  config.enable_reloading = true
  config.consider_all_requests_local = true
  config.eager_load = false
  config.server_timing = true

  # Security
  config.hosts = [Server.domain.dup.prepend('.')]

  # File Watcher
  config.file_watcher = ActiveSupport::EventedFileUpdateChecker

  # Public File Server
  config.public_file_server.enabled = true
  config.public_file_server.headers = { 'cache-control' => "public, max-age=#{2.days.to_i}" } # rubocop:disable Style/StringHashKeys

  # Active Job
  config.active_job.queue_adapter = :solid_queue
  config.active_job.verbose_enqueue_logs = true

  # Active Storage
  config.active_storage.service = :local

  # Mailer
  config.action_mailer.raise_delivery_errors = true
  config.action_mailer.perform_caching = false
  config.action_mailer.delivery_method = :letter_opener

  # Active Support
  config.active_support.deprecation = :raise
  config.active_support.disallowed_deprecation = :raise
  config.active_support.disallowed_deprecation_warnings = []

  # Active Record
  config.active_record.verbose_query_logs = true
  config.active_record.db_warnings_action = :raise

  # Action Controller
  config.action_controller.action_on_unpermitted_parameters = :raise
  config.action_controller.perform_caching = true
  config.action_controller.enable_fragment_cache_logging = true
  config.action_controller.raise_on_missing_callback_actions = true

  # i18n
  config.i18n.raise_on_missing_translations = true

  # Action View
  config.action_view.annotate_rendered_view_with_filenames = true

  # Web Console
  config.web_console.permissions = '192.168.0.0/16'

  # Assets
  config.assets.quiet = true

  # Solid Cache
  config.solid_cache.connects_to = { shards: { cache: { writing: :cache } } }

  # Solid Queue
  config.solid_queue.connects_to = { shards: { queue: { writing: :queue } } }

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
end
