# frozen_string_literal: true

module Schematics
  module Tenantable
    extend ActiveSupport::Concern

    delegate :mod, to: :current_tenant

    included do
      helper_method :current_tenant, :mod
    end

    def current_tenant
      Tenant.new(name: 'dummy') # request.subdomain
    end
  end
end
