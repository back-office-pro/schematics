# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

module Schematics
  class MigrateScheduledSchemaJob < ApplicationJob
    include MultiShardable
    include Quietable
    queue_as :critical

    def perform = for_each_shards do
      migration = ::Migration.scheduled
      return if migration.state_generating?
      return if migration.state_in_progress?

      migration.state_in_progress!
      migration.finalize!(Core::Migrations::Migrate.call(migration:).failure?)
    end
  end
end
