# frozen_string_literal: true

module Schematics
  class MigrateSchemaJob < ApplicationJob
    queue_as :migrations

    class << self
      delegate :info, to: :logger, private: true

      def wait_for(record)
        return if ::Tenant.backend.concurrency.zero?

        Thread.new(record) do |migration|
          info 'Starting thread'
          loop do
            sleep 1
            info 'Waiting for migration to finish...'
            break unless migration.reload.state_in_progress?
          end
          unless migration.state_error?
            info 'Processing schema & file reload'
            ::Tenant.schema = migration.data
            Core::Migrations::Reload.call(migration:)
          end
          info 'Killing thread'
          Thread.current.kill
        end
      end
    end

    # :reek:UncommunicativeVariableName
    def perform(migration)
      PaperTrail.request(enabled: false) do
        migration.finalize! Core::Migrations::Migrate.call(migration:).failure?
      end
    end
  end
end
