# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

module Schematics
  class RollbackSchemaJob < ApplicationJob # rubocop:disable Obsession/Rails/ServiceName
    include Shardable
    include Quietable

    queue_as :critical

    def perform(_shard, migration_id)
      migration = ::Migration.find(migration_id)
      return if migration.state_generating?
      return if migration.state_in_progress?

      migration.finalize!(Core::Migrations::Rollback.call(migration:).failure?)
    end
  end
end
