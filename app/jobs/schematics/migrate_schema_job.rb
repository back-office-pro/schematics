# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

module Schematics
  # :reek:ControlParameter
  class MigrateSchemaJob < ApplicationJob
    include Shardable
    include Quietable
    queue_as :critical

    def perform(_shard, migration_id = nil)
      migration = ::Migration.find_by(id: migration_id) || ::Migration.scheduled
      return unless migration
      return if migration.state_generating?
      return if migration.state_in_progress?

      migration.state_in_progress!
      migration.finalize!(Core::Migrations::Migrate.call(migration:).failure?)
    end
  end
end
