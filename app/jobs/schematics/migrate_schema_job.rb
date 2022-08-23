# frozen_string_literal: true

module Schematics
  class MigrateSchemaJob < ApplicationJob
    delegate :current_database, to: 'ActiveRecord::Base.connection', private: true

    # :reek:UncommunicativeVariableName
    def perform(schema_dataset = ::SchemaDataset.scheduled.last)
      system "pg_dump -F t #{current_database} > migration_#{schema_dataset.id}.tar"
      ::Rails
        .application
        .load_generators
      schema_dataset
        .migration_clean_commands
        .flat_map(&:generators)
        .each(&:invoke_all)
      Schema
        .instance
        .load(schema_dataset.data.to_json)
      ::Rails
        .application
        .reloader
        .reload!
      schema_dataset
        .migration_build_commands
        .flat_map(&:generators)
        .each(&:invoke_all)
      ::Rails
        .application
        .reload_routes!
      schema_dataset.update_column(:state, 2) # rubocop:disable Rails/SkipsModelValidations
      system "rails db:migrate > log/migration_#{schema_dataset.id}.log"
      system 'rails schematics:docs:generate'
      Git
        .init
        .tap do |git|
          git.add(all: true)
          git.commit("Migration #{schema_dataset.id}")
        end
    rescue StandardError => e
      schema_dataset.update_column(:state, 3) # rubocop:disable Rails/SkipsModelValidations
      raise e
    end
  end
end
