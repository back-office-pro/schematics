# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

module Core
  module Subscriptions
    module Stripe
      class Update
        include Interactor

        delegate :secret_key, to: 'Rails.application.credentials.stripe', private: true
        delegate :id, :params, :fail!, to: :context, private: true
        delegate :subscriptions, to: 'client.v1', private: true

        def call
          subscriptions.update(id, params)
        rescue ::Stripe::StripeError
          fail!
        end

        private

        memoize def client = ::Stripe::StripeClient.new(secret_key)
      end
    end
  end
end
