# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

# :reek:MissingSafeMethod
class ::Subscription < Schematics::ApplicationRecord
  GATEWAY = ::Core::Subscriptions::Stripe

  attribute :default_locale, default: -> { Rails.configuration.i18n.default_locale }

  class << self
    delegate :users, :api_keys, to: :quota, prefix: true

    def quota_storage_will_be_exceeded?(size)
      storage_size + size.bytes >= quota_storage
    end

    def quota_users_exceeded?
      users_size >= quota_users
    end

    def quota_api_keys_exceeded?
      api_keys_size >= quota_api_keys
    end

    def quota_storage = quota
      .storage
      .gigabytes

    private

    def quota = Data
      .define(:storage, :users, :api_keys)
      .new(**metadata)

    memoize def storage_size = ActiveStorage::Blob
      .with_deleted
      .sum(&:byte_size)
      .bytes

    memoize def users_size = User.count

    memoize def api_keys_size = APIKey.count
  end

  def load! = update!(GATEWAY::Fetch.call.data)

  def after_enable_event = GATEWAY::Enable.call

  def after_cancel_event = GATEWAY::Cancel.call
end
