# frozen_string_literal: true

module Schematics
  class MigrateSchemaJob < ApplicationJob
    include Quietable
    queue_as :migrations

    def perform(migration = ::Migration.scheduled)
      return unless migration

      migration.finalize!(Core::Migrations::Migrate.call(migration:).failure?)
    end
  end
end
