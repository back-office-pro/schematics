# frozen_string_literal: true

module Schematics
  class MigrateSchemaJob < ApplicationJob
    include Quietable
    queue_as :migrations

    def perform(migration = ::Migration.scheduled)
      return unless migration
      return if migration.state_in_progress?
      return if migration.state_rollbacking?

      migration.finalize!(Core::Migrations::Migrate.call(migration:).failure?)
    end
  end
end
