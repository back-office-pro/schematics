# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

class Tenant
  class << self
    def database_name = ENV.fetch('DATABASE', 'demo')

    def default_url_options = { host:, port: Server.port }.compact

    private

    def host
      return "#{database_name}.#{Server.domain}" if Rails.env.production?

      'localhost'
    end
  end
end
