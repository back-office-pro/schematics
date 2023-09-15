# frozen_string_literal: true

module Core
  module Licences
    module Stripe
      class Fetch
        include Interactor

        delegate :name, to: :product, allow_nil: true, prefix: true, private: true
        delegate :id, :email, to: :customer, allow_nil: true, prefix: true, private: true
        delegate :subdomain, to: ::Tenant, private: true
        delegate :id,
                 :cancel_at_period_end,
                 to: :subscription,
                 allow_nil: true,
                 prefix: true,
                 private: true

        def call
          context.id = subscription_id
          context.data = data
        rescue ::Stripe::StripeError
          context.data = {}
        end

        private

        memoize def product = product_id && ::Stripe::Product.retrieve(product_id)

        memoize def subscription = ::Stripe::Subscription
          .list(customer: customer_id, status: 'active')
          .first

        memoize def customer = ::Stripe::Customer
          .search(query: "name:'#{subdomain}'")
          .data
          .first

        def data = {
          email: customer_email,
          default_locale: customer_locale,
          state: subscription_state,
          plan: product_name,
          metadata: product_metadata
        }.compact

        def subscription_state
          return :inactive unless subscription_id
          return :canceled if subscription_cancel_at_period_end

          :active
        end

        def product_id = subscription
          &.plan
          &.product

        def product_metadata = product
          &.metadata
          &.to_h
          &.transform_values(&:to_i)

        def customer_locale = customer
          &.preferred_locales
          &.first
          &.slice(0, 2)
      end
    end
  end
end
