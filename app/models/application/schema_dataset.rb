# frozen_string_literal: true

module Application
  module SchemaDataset
    extend ActiveSupport::Concern

    prepended do
      serialize :data, Schematics::Schema
      attribute :data, default: -> { current_data || {} }
      delegate :build_commands,
               :clean_commands,
               :new_classes,
               :old_classes,
               to: :migration,
               prefix: true
    end

    class_methods do
      delegate :version, :data, to: :current, prefix: true, allow_nil: true

      def current = migrated.last
    end

    def after_migrate
      Schematics::MigrateSchemaJob.perform_later(self) do
        Schematics::Schema.instance.load(data.to_json)
      end
    end

    def migration
      @migration ||= Schematics::Migrations::DataMigration.new(data, Schematics::Schema.instance)
    end

    def valid?(*)
      return super unless data

      valid = super && data.valid?
      errors.merge!(data)
      valid
    end

    def version = self
      .class
      .with_deleted
      .where(created_at: ..created_at)
      .size
  end
end
