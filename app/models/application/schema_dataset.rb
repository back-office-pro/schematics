# frozen_string_literal: true

module Application
  module SchemaDataset
    extend ActiveSupport::Concern

    prepended do
      serialize :data, Schematics::Schema
      attribute :data, default: -> { current_data || [] }
      validates_associated :data
      delegate :build_commands,
               :clean_commands,
               :old_entities,
               :changed_entities,
               :new_and_changed_entities,
               :old_and_changed_entities,
               to: :migration,
               prefix: true
    end

    class_methods do
      delegate :version, :data, to: :current, prefix: true, allow_nil: true

      def current = migrated.last
    end

    def after_migrate
      Schematics::MigrateSchemaJob.wait_for(self)
      Schematics::MigrateSchemaJob.perform_later(self)
    end

    def migration
      @migration ||= Schematics::Migrations::DataMigration.new(data, ::Tenant.schema)
    end

    def version = self
      .class
      .with_deleted
      .where(created_at: ..created_at)
      .size
      .to_f
      .to_s
      .prepend('v')
  end
end
