# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

module ActiveStorage
  module Override
    module PreviewImageJob
      def perform(_shard, blob_id, variations)
        super(ActiveStorage::Blob.find(blob_id), variations)
      end
    end
  end
end
