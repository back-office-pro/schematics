# frozen_string_literal: true

module Core
  module Licences
    module Stripe
      class Update
        include Interactor
        delegate :id, :params, :fail!, to: :context, private: true

        def call
          ::Stripe::Subscription.update(id, params)
        rescue ::Stripe::StripeError
          fail!
        end
      end
    end
  end
end
