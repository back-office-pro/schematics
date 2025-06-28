# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

module Schematics
  class LoadSubscriptionJob < ApplicationJob
    include Shardable
    include Quietable
    queue_as :critical

    retry_on Stripe::StripeError, wait: :polynomially_longer, attempts: 5

    def perform(_shard)
      ::Subscription.instance.load!
    end
  end
end
