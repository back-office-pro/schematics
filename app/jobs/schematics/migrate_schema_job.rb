# frozen_string_literal: true

module Schematics
  class MigrateSchemaJob < ApplicationJob
    class << self
      def wait_for(record)
        return if ::Tenant.backend.concurrency.zero?

        Thread.new(record) do |migration|
          loop do
            sleep 1
            break unless migration.reload.in_progress?
          end
          unless migration.error?
            ::Tenant.schema = migration.data
            Core::Migrations::Reload.call(migration:)
          end
          Thread.current.kill
        end
      end
    end

    # :reek:UncommunicativeVariableName
    def perform(migration)
      migration.finalize! Core::Migrations::Migrate.call(migration:).failure?
    end
  end
end
