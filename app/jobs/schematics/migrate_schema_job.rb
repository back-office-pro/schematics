# frozen_string_literal: true

module Schematics
  class MigrateSchemaJob < ApplicationJob
    def perform(schema_dataset)
      result = SchemaDatasets::Migrate.call(schema_dataset:)
      return if result.success?

      schema_dataset.update_column(:state, 3) # rubocop:disable Rails/SkipsModelValidations
      raise result.exception
    end
  end
end
