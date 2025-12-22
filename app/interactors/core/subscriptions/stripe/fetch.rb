# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

module Core
  module Subscriptions
    module Stripe
      class Fetch
        include Interactor

        delegate :secret_key, to: 'Rails.application.credentials.stripe', private: true
        delegate :customers, to: 'client.v1', private: true
        delegate :logger, to: '::Rails', private: true
        delegate :id,
                 :metadata,
                 to: :customer,
                 allow_nil: true,
                 prefix: true,
                 private: true
        delegate :id,
                 :cancel_at_period_end,
                 to: :subscription,
                 allow_nil: true,
                 prefix: true,
                 private: true

        after :log_data

        def call
          context.id = subscription_id
          context.data = data
        end

        private

        memoize def client = ::Stripe::StripeClient.new(secret_key)

        memoize def customer = customers
          .search(query: "name:'demo'", expand: ['data.subscriptions'])
          .data
          .first

        def data = {
          default_locale: customer_locale,
          state: subscription_state
        }.compact

        def customer_locale = customer
          &.preferred_locales
          &.first
          &.slice(0, 2)

        def subscription_state
          return :inactive unless subscription_id
          return :canceled if subscription_cancel_at_period_end

          :active
        end

        def subscription = customer
          &.subscriptions
          &.find { %w[active trialing].include?(_1.status) }

        def log_data = logger
          .tagged('Stripe')
          .info(context.data.to_json)
      end
    end
  end
end
