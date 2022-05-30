# frozen_string_literal: true

module MainApp
  module SchemaDataset
    extend ActiveSupport::Concern

    prepended do
      serialize :data, Schematics::Schema
    end

    class_methods do
      delegate :data, :version, to: :current, prefix: true, allow_nil: true

      def current
        migrated.last
      end
    end

    def after_migrate
      Schematics::MigrateSchemaJob.perform_later(id)
    end

    def migrations = data
      .as_json
      .difference(self.class.current_data&.as_json || [])
      .map { data.find_entity_by_name(_1[:name]) }
      .sort_by(&:weight)
      .reverse
      .map { |entity| Schematics::Commands::Command.build(type: 'create_entity', entity:) }

    def version = self
      .class
      .where(created_at: ..created_at)
      .size
  end
end
