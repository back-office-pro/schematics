# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

module Core
  module Subscriptions
    module Stripe
      class Fetch
        include Interactor

        delegate :secret_key, to: 'Schematics::Engine.credentials.stripe', private: true
        delegate :name, to: :product, allow_nil: true, prefix: true, private: true
        delegate :customers, :products, to: 'client.v1', private: true
        delegate :app_name, to: '::Tenant', private: true
        delegate :logger, to: '::Rails', private: true
        delegate :id,
                 :email,
                 :metadata,
                 to: :customer,
                 allow_nil: true,
                 prefix: true,
                 private: true
        delegate :business_sector,
                 to: :customer_metadata,
                 prefix: true,
                 allow_nil: true,
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

        memoize def product = product_id && products.retrieve(product_id)

        memoize def customer = customers
          .search(query: "name:'#{app_name.dasherize}'", expand: ['data.subscriptions'])
          .data
          .first

        def data = {
          email: customer_email,
          default_locale: customer_locale,
          business_sector: customer_metadata_business_sector,
          state: subscription_state,
          plan: product_name,
          metadata: product_metadata
        }.compact

        def customer_locale = customer
          &.preferred_locales
          &.first
          &.slice(0, 2)

        def subscription_state
          return ::Subscription::STATE_STATE_INACTIVE unless subscription_id
          return ::Subscription::STATE_STATE_CANCELED if subscription_cancel_at_period_end

          ::Subscription::STATE_STATE_ACTIVE
        end

        def product_metadata = product
          &.metadata
          &.to_h
          &.transform_values(&:to_i)

        def subscription = customer
          &.subscriptions
          &.find { %w[active trialing].include?(it.status) }

        def product_id = subscription
          &.plan
          &.product

        def log_data = logger
          .tagged('Stripe')
          .info(context.data.to_json)
      end
    end
  end
end
