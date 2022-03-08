# frozen_string_literal: true

module Schematics
  module Resources
    class Duplicate
      include Interactable

      before do
        @resource = context.resource
        @resource.paper_trail_event = :duplicate
      end

      def call
        fail! unless @resource.save
      end
    end
  end
end
