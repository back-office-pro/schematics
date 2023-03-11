# frozen_string_literal: true

module Application
  module Licence
    extend ActiveSupport::Concern

    def load!
      PaperTrail.request(enabled: false) do
        update!(Load.call.data)
        reload && update_env_file if metadata_previously_changed?
      end
    end

    def after_enable
      ::Stripe::Subscription.update(Load.call.id, cancel_at_period_end: false)
    end

    def after_cancel
      ::Stripe::Subscription.update(Load.call.id, cancel_at_period_end: true)
    end

    def entities_size = ::Tenant
      .schema
      .entities
      .reject(&:core?) # rubocop:disable Performance/Count
      .size

    def quota = Data
      .define(:entities, :storage, :users, :databases)
      .new(**metadata)

    def quota_entities_exceeded?
      return true unless active?

      entities_size >= quota.entities
    end

    def quota_entities_percentage
      entities_size * 100 / quota.entities
    end

    def quota_storage_exceeded?
      return true unless active?

      storage_size >= quota.storage
    end

    def quota_storage_percentage
      storage_size * 100 / quota.storage.gigabytes
    end

    def quota_users_exceeded?
      return true unless active?

      users_size >= quota.users
    end

    def quota_users_percentage
      users_size * 100 / quota.users
    end

    def storage_size
      ::ActiveStorage::Blob.sum(&:byte_size)
    end

    def users_size = ::User
      .all
      .size

    private

    def search_engine
      return 'elasticsearch' if quota.databases > 2

      'postgresql'
    end

    def backend
      return 'redis' if quota.databases > 1

      'postgresql'
    end

    def update_env_file
      filepath = Rails.root.join('.env')
      filepath.write filepath
        .read
        .gsub(/BACKEND=(.*)/, "BACKEND=#{backend}")
        .gsub(/SEARCH_ENGINE=(.*)/, "SEARCH_ENGINE=#{search_engine}")
      FileUtils.touch Rails.root.join('tmp/restart.txt')
    end
  end
end
