# frozen_string_literal: true

module Schematics
  class MigrateSchemaJob < ApplicationJob
    # :reek:UncommunicativeVariableName
    def perform(schema_dataset)
      SchemaDatasets::Migrate.call(schema_dataset:)
    rescue StandardError => e
      PaperTrail.request(enabled: false) do
        schema_dataset.state_error!
        Rollbar.error(e, 'Migration error')
      end
    end
  end
end
