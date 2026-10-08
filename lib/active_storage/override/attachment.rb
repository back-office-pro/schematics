# frozen_string_literal: true

module ActiveStorage
  module Override
    module Attachment
      def purge_dependent_blob
        return super if destroyed?

        blob&.destroy!
      end
    end
  end
end
