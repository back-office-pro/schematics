# frozen_string_literal: true

module Schematics
  module Tenantable
    extend ActiveSupport::Concern
    delegate :schema, to: 'Schematics::Tenant.current', prefix: :current, private: true

    included do
      helper_method :current_schema
    end
  end
end
