# frozen_string_literal: true

module Application
  module Licence
    extend ActiveSupport::Concern

    def load!
      PaperTrail.request(enabled: false) do
        update!(Load.call.data)
      end
    end

    def active? = active

    def entities_size = self
      .class
      .tenant
      .schema
      .entities
      .reject(&:core?) # rubocop:disable Performance/Count
      .size

    def quota = Struct
      .new(:entities, :storage, :users, keyword_init: true)
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

    def storage_size = ::ActiveStorage::Attachment
      .preload(:blob)
      .sum(&:byte_size)

    def users_size = ::User
      .all
      .size
  end
end
