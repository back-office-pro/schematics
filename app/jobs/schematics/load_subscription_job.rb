# frozen_string_literal: true

module Schematics
  class LoadSubscriptionJob < ApplicationJob
    include Quietable

    retry_on Stripe::StripeError, wait: :polynomially_longer, attempts: 5 do |_job, error|
      Rollbar.error(error)
    end

    def perform = ::Subscription
      .instance
      .load!
  end
end
