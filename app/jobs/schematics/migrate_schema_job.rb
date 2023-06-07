# frozen_string_literal: true

module Schematics
  class MigrateSchemaJob < ApplicationJob
    class << self
      def wait_for(record)
        return if ::Tenant.backend.concurrency.zero?

        Thread.new(record) do |schema_dataset|
          schema_dataset_with_old_migration = schema_dataset.dup.tap(&:migration)
          loop do
            sleep 1
            break unless schema_dataset.reload.in_progress?
          end
          if schema_dataset.migrated?
            ::Tenant.schema = schema_dataset.data
            Core::SchemaDatasets::Reload.call(schema_dataset: schema_dataset_with_old_migration)
          end
          Thread.current.kill
        end
      end
    end

    # :reek:UncommunicativeVariableName
    def perform(schema_dataset)
      result = Core::SchemaDatasets::Migrate.call(schema_dataset:)
      return schema_dataset.state_error! if result.failure?

      schema_dataset
        .tap(&:state_migrated!)
        .dump!
    end
  end
end
