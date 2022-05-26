# frozen_string_literal: true

module Schematics
  class MigrateSchemaJob < ApplicationJob
    def perform
      schema_dataset = ::SchemaDataset.awaiting
      Schema.load(schema_dataset.data.to_json)
      schema_dataset
        .migrations
        .flat_map(&:execute)
        .each(&method(:system))
      ::Rails.application.reload_routes!
      system 'rails db:migrate'
      system 'rails schematics:docs:generate'
      system 'rails js:routes'
    end
  end
end
