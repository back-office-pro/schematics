# frozen_string_literal: true

module Schematics
  class MigrateSchemaJob < ApplicationJob
    def perform(data)
      Schema.instance.load(data:)
      Schema
        .instance
        .sorted_entities
        .reject(&:core?)
        .map { |entity| Commands::CreateEntity.new(entity:) }
        .flat_map(&:execute)
        .each(&method(:system))
      system 'rails db:migrate'
      system 'rails schematics:docs:generate'
      system 'rails js:routes'
    end
  end
end
