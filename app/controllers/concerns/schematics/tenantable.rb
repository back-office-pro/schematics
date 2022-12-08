# frozen_string_literal: true

module Schematics
  module Tenantable
    extend ActiveSupport::Concern
    included do
      helper_method :current_tenant, :current_schema
    end

    def current_tenant
      Tenant.new(name: 'dummy') # request.subdomain
    end

    def current_schema
      tenant.schema
    end
  end
end
