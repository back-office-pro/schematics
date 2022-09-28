# frozen_string_literal: true

module Stripe
  module Gateway
    class LicenceLoader
      delegate :tenant, to: 'Schematics::Engine', private: true
      delegate :email, to: :customer
      delegate :name, to: :product, allow_nil: true

      def dump = { email:, name:, quota: }

      private

      def customer
        @customer ||= Customer
                      .search(query: "name:'#{tenant}'")
                      .data
                      .first
      end

      def product
        @product ||= product_id && Product.retrieve(product_id)
      end

      def product_id = subscription
        &.plan
        &.product

      def quota = product
        &.metadata
        &.to_h
        &.transform_values(&:to_i)

      def subscription = Subscription
        .list(customer: customer.id, status: 'active')
        .first
    end
  end
end
