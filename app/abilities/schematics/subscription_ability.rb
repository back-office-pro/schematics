# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

module Schematics
  class SubscriptionAbility < ApplicationAbility
    def initialize(user, mod)
      super
      cannot %i[create restore], mod::User if mod::Subscription.quota_users_exceeded?
      cannot %i[create restore], mod::APIKey if mod::Subscription.quota_api_keys_exceeded?
      cannot %i[create restore update], :all if mod::Subscription.instance.state_inactive?
      return unless user.admin?

      can %i[cancel enable], mod::Subscription
    end
  end
end
