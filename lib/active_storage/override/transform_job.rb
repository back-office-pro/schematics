# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

module ActiveStorage
  module Override
    module TransformJob
      def perform(_shard, blob_id, transformations)
        super(ActiveStorage::Blob.find(blob_id), transformations)
      end
    end
  end
end
