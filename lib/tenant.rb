# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

require 'pg'

class Tenant
  class << self
    def database_name = ENV.fetch('DATABASE', 'demo')

    def default_url_options = { host:, port: Server.port }.compact

    def database = %i[sqlite3 postgresql][database_index]

    private

    def host
      return "#{database_name}.#{Server.domain}" if Rails.env.production?

      'localhost'
    end

    def database_index
      PG
        .connect(connect_timeout: 1)
        .exec("SELECT 1 FROM pg_database WHERE datname='#{database_name}_#{Rails.env}'")
        .count
    rescue PG::Error
      0
    end
  end
end
