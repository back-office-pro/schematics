# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

module ActiveStorage
  module Override
    module Blob
      def purge
        really_destroy!
        super
      end

      def purge_later
        ActiveStorage::PurgeJob.perform_later(current_shard, id)
      end

      def create_preview_image_later(variations)
        return unless representable?

        ActiveStorage::PreviewImageJob.perform_later(current_shard, id, variations)
      end

      def preprocessed(transformations)
        return unless representable?

        ActiveStorage::TransformJob.perform_later(current_shard, id, transformations)
      end

      def analyze_later
        return analyze unless analyzer_class.analyze_later?

        ActiveStorage::AnalyzeJob.perform_later(current_shard, id)
      end
    end
  end
end
