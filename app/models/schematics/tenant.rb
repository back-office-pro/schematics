# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

module Schematics
  # :reek:Attribute
  class Tenant
    include ::ActiveModel::API
    attr_writer :subdomain

    def subdomain
      @subdomain.presence || Rails.application.class.module_parent_name.dasherize
    end

    def demo?
      subdomain == 'Demo' && !Rails.env.test?
    end
  end
end
