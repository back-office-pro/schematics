# frozen_string_literal: true

module Core
  module WebhookEndpoints
    class SubscribedQuery < Schematics::ApplicationQuery
      def call(event)
        where(subscriptions: [event])
      end
    end
  end
end
