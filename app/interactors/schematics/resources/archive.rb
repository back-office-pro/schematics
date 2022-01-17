# frozen_string_literal: true

module Schematics
  module Resources
    class Archive
      include Interactable

      before do
        @resource = context.resource
        @resource.paper_trail_event = :archive
      end

      def call
        fail! unless @resource.destroy
      end
    end
  end
end
