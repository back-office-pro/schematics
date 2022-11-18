# frozen_string_literal: true

module Schematics
  class MigrateSchemaJob < ApplicationJob
    def perform(schema_dataset)
      result = SchemaDatasets::Migrate.call(schema_dataset:)
      return if result.success?

      PaperTrail.request(enabled: false) do
        schema_dataset.state_error!
      end
    end
  end
end
