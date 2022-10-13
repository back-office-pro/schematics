# frozen_string_literal: true

require 'active_storage/service/s3_service'

module ActiveStorage
  class Service::TenantS3Service < Service
    private

    def object_for(key)
      bucket.object ::File.join(Schematics::Engine.tenant.dasherize, key)
    end
  end
end
