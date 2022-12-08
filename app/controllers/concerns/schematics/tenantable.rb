# frozen_string_literal: true

module Schematics
  module Tenantable
    extend ActiveSupport::Concern

    included do
      helper_method :current_tenant
    end

    def current_tenant = Tenant.current
  end
end
