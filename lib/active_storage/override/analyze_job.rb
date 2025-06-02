# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

module ActiveStorage
  module Override
    module AnalyzeJob
      def perform(_shard, blob_id)
        super(ActiveStorage::Blob.find(blob_id))
      end
    end
  end
end
