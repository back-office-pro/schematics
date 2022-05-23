# frozen_string_literal: true

module MainApp
  module SchemaDataset
    extend ActiveSupport::Concern

    prepended do
      serialize :data, Schematics::Schema
    end

    class_methods do
      def current = migrated
        .order(created_at: :desc)
        .first

      def awaiting = scheduled
        .order(created_at: :desc)
        .first
    end

    def after_migrate
      Schematics::MigrateSchemaJob.perform_later(data)
    end
  end
end
