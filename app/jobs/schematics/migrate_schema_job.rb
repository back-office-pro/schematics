# frozen_string_literal: true

module Schematics
  class MigrateSchemaJob < ApplicationJob
    def perform(data = ::SchemaDataset.awaiting.data.to_json)
      Schema
        .load(data)
        .sorted_entities
        .reject(&:core?)
        .map { |entity| Commands::CreateEntity.new(entity:) }
        .flat_map(&:execute)
        .each(&method(:system))
      ::Rails.application.reload_routes!
      system 'rails db:migrate'
      system 'rails schematics:docs:generate'
      system 'rails js:routes'
    end
  end
end
