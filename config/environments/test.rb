# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

require 'active_support/core_ext/integer/time'
require 'server'

Rails.application.routes.default_url_options = { host: "default.#{Server.domain}" }
Rails.application.configure do
  # Configuration
  config.enable_reloading = false
  config.consider_all_requests_local = true
  config.eager_load = ENV['CI'].present?

  # Public File Server
  config.public_file_server.enabled = true
  config.public_file_server.headers = { 'cache-control' => "public, max-age=#{1.hour.to_i}" } # rubocop:disable Style/StringHashKeys

  # Action Dispatch
  config.action_dispatch.show_exceptions = :rescuable

  # Action Controller
  config.action_controller.perform_caching = false
  config.action_controller.allow_forgery_protection = false
  config.action_controller.raise_on_missing_callback_actions = true

  # Active Job
  config.active_job.queue_adapter = :test

  # Active Storage
  config.active_storage.service = :test

  # Mailer
  config.action_mailer.perform_caching = false
  config.action_mailer.delivery_method = :test

  # Active Support
  config.active_support.deprecation = :stderr
  config.active_support.disallowed_deprecation = :raise
  config.active_support.disallowed_deprecation_warnings = []

  # i18n
  config.i18n.raise_on_missing_translations = true

  # Action View
  config.action_view.annotate_rendered_view_with_filenames = true

  # Cache
  config.cache_store = :memory_store
end
