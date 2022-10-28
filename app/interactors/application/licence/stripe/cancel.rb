# frozen_string_literal: true

module Application
  module Licence
    module Stripe
      class Cancel
        include Schematics::Interactable
        delegate :id, to: :context, private: true

        def call
          fail! unless ::Stripe::Subscription.update(id, cancel_at_period_end: true)
        end
      end
    end
  end
end
