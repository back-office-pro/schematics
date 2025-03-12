# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

# :reek:MissingSafeMethod
module Core
  module Subscription
    extend ActiveSupport::Concern

    GATEWAY = Subscriptions::Stripe

    prepended do
      attribute :default_locale, default: -> { Rails.configuration.i18n.default_locale }
    end

    class_methods do
      delegate :entities, :users, :api_keys, to: :quota, prefix: true

      def quota_storage_will_be_exceeded?(size)
        storage_size + size.bytes >= quota_storage
      end

      def quota_users_exceeded?
        users_size >= quota_users
      end

      def quota_api_keys_exceeded?
        api_keys_size >= quota_api_keys
      end

      def email_support? = !live_support?

      def live_support? = quota
        .support
        .eql?(2)

      def quota_storage = quota
        .storage
        .gigabytes

      private

      def quota = Data
        .define(:entities, :storage, :users, :api_keys, :support)
        .new(**metadata)

      def storage_size = ActiveStorage::Blob
        .with_deleted
        .sum(&:byte_size)
        .bytes

      def users_size = ::User.count

      def api_keys_size = ::APIKey.count
    end

    def load!
      PaperTrail.request(enabled: false) do
        update!(GATEWAY::Fetch.call.data)
      end
    end

    def after_enable_event = GATEWAY::Enable.call

    def after_cancel_event = GATEWAY::Cancel.call
  end
end
