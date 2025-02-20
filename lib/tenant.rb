# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

require 'active_support/core_ext/module/delegation'
require 'pg'

class Tenant
  class << self
    delegate :port, to: 'Server', private: true

    def app_name = Rails
      .application
      .class
      .module_parent_name
      .underscore

    def default_url_options = { host:, port: }.compact

    def database = %i[sqlite3 postgresql][database_index]

    private

    def host
      return "#{app_name.dasherize}.#{Server.domain}" if Rails.env.production?

      'localhost'
    end

    def database_index
      PG
        .connect(connect_timeout: 1)
        .exec("SELECT 1 FROM pg_database WHERE datname='#{app_name}_#{Rails.env}'")
        .count
    rescue PG::Error
      0
    end
  end
end
