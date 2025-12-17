# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

require 'active_storage/service/s3_service'

module ActiveStorage
  class Service::TenantS3Service < Service::S3Service
    private

    def object_for(key)
      bucket.object ::File.join(Record.current_shard.to_s, key)
    end
  end
end
