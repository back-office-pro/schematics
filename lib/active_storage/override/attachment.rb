# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

module ActiveStorage
  module Override
    module Attachment
      def purge_dependent_blob_later
        return super if destroyed?

        blob&.destroy!
      end
    end
  end
end
