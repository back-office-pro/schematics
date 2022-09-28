# frozen_string_literal: true

module Main
  class Licence < MainRecord
    self.table_name = 'licences' # rubocop:disable Rails/TableNameAssignment

    LICENCES = YAML
               .load_file(Schematics::Engine.root.join('lib', 'licences.yml'))
               .freeze

    def entities_size = Schematics::Schema
      .instance
      .entities
      .reject(&:core?) # rubocop:disable Performance/Count
      .size

    def expired?
      return true unless expires_on

      ::Date.current.after?(expires_on)
    end

    def quota = Struct
      .new(:users, :storage, :entities, keyword_init: true)
      .new(LICENCES[plan])

    def quota_entities_exceeded?
      entities_size >= quota.entities
    end

    def quota_entities_percentage
      entities_size * 100 / quota.entities
    end

    def quota_storage_exceeded?
      storage_size >= quota.storage
    end

    def quota_storage_percentage
      storage_size * 100 / quota.storage.gigabytes
    end

    def quota_users_exceeded?
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
