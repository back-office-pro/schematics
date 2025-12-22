# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

module Schematics
  class LoadSubscriptionJob < ApplicationJob
    include Quietable

    queue_as :critical

    def perform = ::Subscription
      .instance
      .state_active!
  end
end
