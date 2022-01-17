# frozen_string_literal: true

module Schematics
  module Resources
    class Restore
      include Interactable

      before do
        @resource = context.resource
        @resource.paper_trail_event = :restore
      end

      def call
        fail! unless @resource.restore(recursive: true)
      end
    end
  end
end
