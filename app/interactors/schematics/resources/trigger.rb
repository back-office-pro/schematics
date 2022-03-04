# frozen_string_literal: true

module Schematics
  module Resources
    class Trigger
      include Interactable

      before do
        @resource = context.resource
        @event = context.event
        @resource.paper_trail_event = @event.name.to_sym
      end

      def call
        fail! unless @resource.public_send(@event.name.to_sym)
      end
    end
  end
end
