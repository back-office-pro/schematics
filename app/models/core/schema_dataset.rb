# frozen_string_literal: true

class SchemaDataset < Schematics::ApplicationRecord
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

  class << self
    delegate :data_version, :data, to: :current, prefix: true, allow_nil: true

    def current = migrated.last
  end

  def after_migrate
    Schematics::MigrateSchemaJob.wait_for(self)
    Schematics::MigrateSchemaJob.perform_later(self)
  end

  def migration
    @migration ||= Schematics::Migration.new(data, Tenant.schema)
  end
end
