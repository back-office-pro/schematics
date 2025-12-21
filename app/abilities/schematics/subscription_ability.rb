# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

module Schematics
  class SubscriptionAbility < ApplicationAbility
    delegate :state_inactive?, to: '::Subscription.instance', private: true
    delegate :quota_users_exceeded?,
             :quota_api_keys_exceeded?,
             to: '::Subscription',
             private: true

    def initialize
      super
      cannot %i[create restore], ::User if quota_users_exceeded?
      cannot %i[create restore], ::APIKey if quota_api_keys_exceeded?
      cannot %i[create restore update], :all if state_inactive?
    end
  end
end
