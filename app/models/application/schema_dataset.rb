# frozen_string_literal: true

module Application
  module SchemaDataset
    extend ActiveSupport::Concern

    prepended do
      serialize :data, Schematics::Schema
      delegate :build_commands, :clean_commands, to: :migration, prefix: true
      delegate :valid?, :errors, to: :data
    end

    class_methods do
      delegate :version, to: :current, prefix: true, allow_nil: true

      def current
        migrated.last
      end
    end

    def after_migrate
      Schematics::MigrateSchemaJob.perform_later(self) do
        Schematics::Schema.instance.load(data.to_json)
      end
    end

    def migration
      @migration ||= Schematics::Migration.new(data)
    end

    def version = self
      .class
      .where(created_at: ..created_at)
      .size
  end
end
