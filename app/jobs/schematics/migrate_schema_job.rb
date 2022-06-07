# frozen_string_literal: true

module Schematics
  class MigrateSchemaJob < ApplicationJob
    def perform(schema_dataset_id = ::SchemaDataset.scheduled.last&.id)
      schema_dataset = ::SchemaDataset.find(schema_dataset_id)
      Schema.instance.load(schema_dataset.data.to_json)
      schema_dataset
        .migrations
        .flat_map(&:execute)
        .each(&method(:system))
      schema_dataset.update_column(:state, 2) # rubocop:disable Rails/SkipsModelValidations
      ::Rails.application.reload_routes!
      system 'rails db:migrate'
      system 'rails schematics:docs:generate'
      system 'rails js:routes'
    rescue StandardError => e
      schema_dataset.update_column(:state, 3) # rubocop:disable Rails/SkipsModelValidations
      raise e
    end
  end
end
