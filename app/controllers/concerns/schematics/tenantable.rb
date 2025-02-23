# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

module Schematics
  module Tenantable
    extend ActiveSupport::Concern

    included do
      helper_method :current_tenant
      helper_method :current_schema
    end

    def current_tenant
      Tenant.new(subdomain: request.subdomain)
    end

    def current_schema
      ::SchemaCache.fetch('current')
    end
  end
end
