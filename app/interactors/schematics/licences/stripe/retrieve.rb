# frozen_string_literal: true

module Schematics
  module Licences
    module Stripe
      class Retrieve
        include Interactor

        delegate :tenant, to: 'Schematics::Engine', private: true
        delegate :email, to: :customer, allow_nil: true, private: true
        delegate :name, to: :product, allow_nil: true, private: true
        delegate :id, to: :subscription, allow_nil: true, private: true

        def call
          context.id = id
          context.email = email
          context.name = name
          context.quota = quota
        end

        private

        def customer
          @customer ||= ::Stripe::Customer
                        .search(query: "name:'#{tenant}'")
                        .data
                        .first
        end

        def product
          @product ||= product_id && ::Stripe::Product.retrieve(product_id)
        end

        def product_id = subscription
          &.plan
          &.product

        def quota = product
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
