# frozen_string_literal: true

module Schematics
  class MigrateSchemaJob < ApplicationJob
    def perform(data)
      Schematics::Schema.instance.load(data:)
      Schematics::Schema
        .instance
        .sorted_entities
        .reject(&:core)
        .map { |entity| Schematics::Commands::CreateEntity.new(entity:) }
        .flat_map(&:execute)
        .each(&method(:system))
      system 'rails db:migrate'
      system 'rails schematics:docs:generate'
      system 'rails js:routes'
    end
  end
end
