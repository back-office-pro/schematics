# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

module Schematics
  class LoadSubscriptionJob < ApplicationJob
    include Quietable

    queue_as :critical

    retry_on Stripe::StripeError, wait: :polynomially_longer, attempts: 5

    def perform = ::Subscription
      .instance
      .load!
  end
end
