# frozen_string_literal: true

require 'active_storage/service/disk_service'

module ActiveStorage
  class Service::DiskWithHostService < Service::DiskService # rubocop:disable Style/ClassAndModuleChildren
    # :reek:UtilityFunction
    def url_options = ::Tenant.default_url_options
  end
end
