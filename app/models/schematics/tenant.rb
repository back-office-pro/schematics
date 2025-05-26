# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

module Schematics
  # :reek:Attribute
  class Tenant
    include ::ActiveModel::API
    attr_accessor :subdomain

    def demo?
      subdomain == 'demo' && !Rails.env.test?
    end
  end
end
