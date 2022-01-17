# frozen_string_literal: true

module Schematics
  module Versions
    class Revert
      include Interactable

      before do
        @version = context.version
      end

      def call
        fail! unless revert_or_destroy!
      end

      private

      def revert_or_destroy!
        @version.reify&.unstale&.save || @version.item.really_destroy!
      end
    end
  end
end
