# frozen_string_literal: true

module Core
  module WebhookEndpoints
    class SubscribedQuery < Schematics::ApplicationQuery
      def call(event)
        where(arel_table[:subscriptions].any(event))
      end
    end
  end
end
