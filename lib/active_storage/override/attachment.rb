# frozen_string_literal: true

module ActiveStorage
  module Override
    module Attachment
      def purge_dependent_blob_later
        super if destroyed?
      end
    end
  end
end
