# frozen_string_literal: true

module Schematics
  class MigrateSchemaJob < ApplicationJob
    # :reek:UncommunicativeVariableName
    def perform(schema_dataset = ::SchemaDataset.scheduled.last)
      Schema.instance.load(schema_dataset.data.to_json)
      schema_dataset
        .migration_commands
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
