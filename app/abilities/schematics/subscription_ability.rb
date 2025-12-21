# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

module Schematics
  class SubscriptionAbility < ApplicationAbility
    delegate :state_inactive?, to: '::Subscription.instance', private: true

    def initialize
      super
      cannot %i[create restore update], :all if state_inactive?
    end
  end
end
