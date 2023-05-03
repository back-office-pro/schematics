# frozen_string_literal: true

module Core
  module Licences
    class Load
      include Interactor
      delegate :name, to: :product, allow_nil: true, private: true
      delegate :id, :cancel_at_period_end, to: :subscription, allow_nil: true, private: true

      def call
        context.id = id
        context.data = { state:, plan: name, metadata: }
      rescue ::Stripe::StripeError
        context.data = {}
      end

      private

      def state
        return :inactive unless id
        return :canceled if cancel_at_period_end

        :active
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
        .list(customer: ::Tenant.customer_id, status: 'active')
        .first
    end
  end
end
