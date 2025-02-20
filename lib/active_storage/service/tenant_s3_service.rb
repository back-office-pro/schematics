# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

require 'active_storage/service/s3_service'

module ActiveStorage
  class Service::TenantS3Service < Service::S3Service # rubocop:disable Style/ClassAndModuleChildren
    private

    def object_for(key)
      bucket.object ::File.join(Tenant.app_name.dasherize, key)
    end
  end
end
