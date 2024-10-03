# frozen_string_literal: true

module Core
  module Subscriptions
    module Stripe
      class Update
        include Interactor

        delegate :id, :params, :fail!, to: :context, private: true
        delegate :subscriptions, to: 'client.v1', private: true
        delegate :credentials, to: ::Schematics::Engine, private: true
        delegate :env, to: ::Rails, private: true

        def call
          subscriptions.update(id, params)
        rescue ::Stripe::StripeError
          fail!
        end

        private

        memoize def client = ::Stripe::StripeClient.new(
          credentials.dig(:stripe, env.to_sym, :secret_key)
        )
      end
    end
  end
end
