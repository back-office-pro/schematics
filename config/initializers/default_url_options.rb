# frozen_string_literal: true

Rails.application.default_url_options = ::Tenant.current.default_url_options
Rails.application.routes.default_url_options = ::Tenant.current.default_url_options
Rails.configuration.action_controller.default_url_options = ::Tenant.current.default_url_options
Rails.configuration.action_mailer.default_url_options = ::Tenant.current.default_url_options
Rails.configuration.action_mailer.default_options = ::Tenant.current.default_mailer_options
