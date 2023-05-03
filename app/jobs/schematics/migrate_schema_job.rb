# frozen_string_literal: true

module Schematics
  class MigrateSchemaJob < ApplicationJob
    class << self
      def wait_for(record)
        return if ::Tenant.backend.concurrency.zero?

        Thread.new(record) do |schema_dataset|
          loop do
            sleep 1
            break if schema_dataset.reload.migrated?
          end
          schema_dataset.migration # force migration to be set before changing schema
          ::Tenant.schema = schema_dataset.data
          Core::SchemaDatasets::Reload.call(schema_dataset:)
          Thread.current.kill
        end
      end
    end

    # :reek:UncommunicativeVariableName
    def perform(schema_dataset)
      Core::SchemaDatasets::Migrate.call(schema_dataset:)
    rescue StandardError => e
      PaperTrail.request(enabled: false) do
        schema_dataset.state_error!
        Rollbar.error(e, 'Migration error')
      end
    end
  end
end
