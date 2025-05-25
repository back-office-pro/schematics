# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

module Schematics
  # :reek:Attribute
  class Tenant
    include ::ActiveModel::API
    delegate :port, :domain, to: '::Server', private: true
    attr_accessor :subdomain

    def demo?
      subdomain == 'demo' && !Rails.env.test?
    end

    def default_url_options = { host:, port: }.compact

    private

    def host
      return domain if Rails.env.on_premise?
      return "#{subdomain}.localhost.me" if Rails.env.local?

      "#{subdomain}.#{domain}"
    end
  end
end
