# frozen_string_literal: true

module Schematics
  module Tenantable
    extend ActiveSupport::Concern

    included do
      helper_method :current_schema
    end

    private

    def current_schema = ::Tenant.schema
  end
end
