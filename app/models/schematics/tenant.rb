# frozen_string_literal: true

module Schematics
  # :reek:Attribute
  class Tenant
    include ::ActiveModel::API
    attr_writer :subdomain

    def subdomain
      @subdomain.presence || Rails.application.class.module_parent_name.underscore
    end

    def demo?
      subdomain == 'demo'
    end
  end
end
