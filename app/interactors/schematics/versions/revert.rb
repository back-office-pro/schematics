# frozen_string_literal: true

module Schematics
  module Versions
    class Revert
      include Interactable

      before do
        @version = context.version
        @resource = @version.reify.unstale
        @resource.paper_trail_event = :revert
      end

      def call
        fail! unless @resource.save
      end
    end
  end
end
