# frozen_string_literal: true

# :reek:MissingSafeMethod
class Migration < Schematics::ApplicationRecord
  serialize :data, Schematics::Schema
  attribute :data, default: -> { current_data || [] }
  validates_associated :data
  delegate :data, to: :previous_migration, prefix: true
  delegate :build_commands,
           :clean_commands,
           :old_entities,
           :changed_entities,
           :new_and_changed_entities,
           :old_and_changed_entities,
           to: :migrator,
           prefix: true

  class << self
    delegate :data_version, :data, to: :current, prefix: true, allow_nil: true

    def current = finished.last

    def core = new(data: Tenant.schema.as_json, data_version: current_data_version)
  end

  def after_migrate_event
    Schematics::MigrateSchemaJob.wait_for(self)
    Schematics::MigrateSchemaJob.perform_later(self)
  end

  def after_rollback_event
    Schematics::MigrateSchemaJob.wait_for(previous_migration)
    Schematics::MigrateSchemaJob.perform_later(previous_migration)
  end

  memoize def migrator = Schematics::Migrator.new(data, previous_migration_data)

  def to_yaml = { one: { state: 'finished', data_version:, data: data.as_json } }
    .deep_stringify_keys
    .to_yaml

  private

  def previous_migration = self
    .class
    .finished
    .excluding(self)
    .order(created_at: :desc)
    .find_by(created_at: ..created_at) || self.class.new(data: Schematics::Schema.new)
end
