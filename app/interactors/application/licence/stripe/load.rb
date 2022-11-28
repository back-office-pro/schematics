# frozen_string_literal: true

module Application
  module Licence
    module Stripe
      class Load
        include Interactor

        delegate :subdomain, to: '::Tenant', private: true
        delegate :email, :preferred_locales, to: :customer, allow_nil: true, private: true
        delegate :name, to: :product, allow_nil: true, private: true
        delegate :id, to: :subscription, allow_nil: true, private: true

        def call
          context.id = id
          context.data = { active:, plan: name, email:, locale:, metadata: }
        rescue ::Stripe::StripeError
          context.data = {}
        end

        private

        def active = id.present?

        def locale = preferred_locales
          &.first
          &.slice(0, 2)

        def customer
          @customer ||= ::Stripe::Customer
                        .search(query: "name:'#{subdomain}'")
                        .data
                        .first
        end

        def product
          @product ||= product_id && ::Stripe::Product.retrieve(product_id)
        end

        def product_id = subscription
          &.plan
          &.product

        def metadata = product
          &.metadata
          &.to_h
          &.transform_values(&:to_i)

        def subscription = ::Stripe::Subscription
          .list(customer: customer&.id, status: 'active')
          .first
      end
    end
  end
end
