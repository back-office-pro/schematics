# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

# :reek:MissingSafeMethod
class ::Subscription < Schematics::ApplicationRecord
  GATEWAY = ::Core::Subscriptions::Stripe

  attribute :default_locale, default: -> { Rails.configuration.i18n.default_locale }

  class << self
    delegate :users, :api_keys, to: :quota, prefix: true

    def quota_users_exceeded?
      users_size >= quota_users
    end

    def quota_api_keys_exceeded?
      api_keys_size >= quota_api_keys
    end

    private

    def quota = Data
      .define(:users, :api_keys)
      .new(**metadata)

    memoize def users_size = User.count

    memoize def api_keys_size = APIKey.count
  end

  def load! = update!(GATEWAY::Fetch.call.data)
end
