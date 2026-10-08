# frozen_string_literal: true

module Schematics
  class MigrateSchemaJob < ApplicationJob
    include Quietable

    queue_as :critical

    def perform(migration = ::Migration.scheduled)
      return unless migration
      return if migration.state_reasoning?
      return if migration.state_in_progress?

      migration.state_in_progress!
      migration.finalize!(Core::Migrations::Migrate.call(migration:).failure?)
    end
  end
end
