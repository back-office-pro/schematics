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
      Schematics::MigrateSchemaJob.perform_later(data.to_json)
    end

    def version = self
      .class
      .where(created_at: ..created_at)
      .size
  end
end
