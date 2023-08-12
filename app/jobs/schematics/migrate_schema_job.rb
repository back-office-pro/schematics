# frozen_string_literal: true

module Schematics
  class MigrateSchemaJob < ApplicationJob
    class << self
      def wait_for(record)
        return if ::Tenant.backend.concurrency.zero?

        Thread.new(record) do |migration|
          migration_with_old_migrator = migration.dup.tap(&:migrator)
          loop do
            sleep 1
            break unless migration.reload.in_progress?
          end
          if migration.finished?
            ::Tenant.schema = migration.data
            Core::Migrations::Reload.call(migration: migration_with_old_migrator)
          end
          Thread.current.kill
        end
      end
    end

    # :reek:UncommunicativeVariableName
    def perform(migration)
      result = Core::Migrations::Migrate.call(migration:)
      return migration.state_error! if result.failure?

      migration.state_finished!
    end
  end
end
