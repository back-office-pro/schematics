# frozen_string_literal: true

module MainApp
  module SchemaDataset
    extend ActiveSupport::Concern

    prepended do
      serialize :data, Schematics::Schema
    end

    class_methods do
      delegate :data, :version, to: :current, prefix: true, allow_nil: true

      def awaiting = scheduled
        .order(created_at: :desc)
        .first

      def current = migrated
        .order(created_at: :desc)
        .first
    end

    def after_migrate
      Schematics::MigrateSchemaJob.perform_later
    end

    def migrations
      current_data = self.class.current.data&.as_json || []
      current_data
        .difference(data.as_json)
        .map do |entity|
          Schematics::Commands::Command.build(type: 'create_entity', entity: entity[:name])
        end
    end

    def version = self
      .class
      .where(created_at: ..created_at)
      .size
  end
end
