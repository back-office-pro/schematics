# frozen_string_literal: true

module Schematics
  module Resources
    class Trigger
      include Interactor

      before do
        @resource = context.resource
        @event = context.event
        @resource.paper_trail_event = @event.name.to_sym
      end

      def call
        if @resource.public_send(:"#{@event.name}!")
          context.message = '.success'
        else
          context.fail!(message: '.failure')
        end
      end
    end
  end
end
