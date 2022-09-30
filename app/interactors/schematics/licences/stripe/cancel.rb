# frozen_string_literal: true

module Schematics
  module Licences
    module Stripe
      class Cancel
        include Interactable
        delegate :id, to: 'Schematics::Licence.instance', private: true

        def call
          fail! unless ::Stripe::Subscription.update(id, cancel_at_period_end: true)
        end
      end
    end
  end
end
