# frozen_string_literal: true

module Schematics
  class MigrateSchemaJob < ApplicationJob
    delegate :current_database, to: 'ActiveRecord::Base.connection', private: true

    # :reek:UncommunicativeVariableName
    def perform(schema_dataset = ::SchemaDataset.scheduled.last)
      system "pg_dump -F t #{current_database} > migration_#{migration_time}.tar"
      system 'bundle exec spring server &'
      schema_dataset
        .migration_commands
        .flat_map(&:execute)
        .each(&method(:system))
      schema_dataset.update_column(:state, 2) # rubocop:disable Rails/SkipsModelValidations
      Schema.instance.load(schema_dataset.data.to_json)
      ::Rails.application.reload_routes!
      system 'rails db:migrate'
      system 'rails schematics:docs:generate'
      system 'rails js:routes'
      system 'git add -A'
      system "git commit -m 'Migration #{schema_dataset.id}'"
      system 'bundle exec spring stop'
    rescue StandardError => e
      schema_dataset.update_column(:state, 3) # rubocop:disable Rails/SkipsModelValidations
      raise e
    end

    private

    def migration_time
      @migration_time ||= ::Time.current.to_json
    end

    def system(command)
      super "#{command} >> log/migration_#{migration_time}.log"
    end
  end
end
