# frozen_string_literal: true

module Core
  module WebhookEndpoints
    class SubscribedQuery < Schematics::ApplicationQuery
      def call(event)
        eager_load(:events).where(events: { id: [event.id] })
      end
    end
  end
end
