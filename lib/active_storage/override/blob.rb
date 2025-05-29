# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

module ActiveStorage
  module Override
    module Blob
      def key
        self[:key] ||= [current_shard, super].join('/')
      end

      def purge
        really_destroy!
        super
      end
    end
  end
end
