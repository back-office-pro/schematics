# frozen_string_literal: true

# :reek:MissingSafeMethod
class Migration < Schematics::ApplicationRecord
  serialize :data, Schematics::Schema
  attribute :data, default: -> { current_data || [] }
  validates_associated :data
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

  alias after_rollback_event after_migrate_event

  memoize def migrator
    return Schematics::Migrator.new(previously_migrated_schema, data) if rollbacking?

    Schematics::Migrator.new(data, previously_migrated_schema)
  end

  def commit_message
    return "Rollback v#{data_version} (core v#{Schematics::VERSION})" if rollbacking?

    "Migration v#{data_version} (core v#{Schematics::VERSION})"
  end

  # :reek:ControlParameter
  def finalize!(failure)
    return state_error! if failure
    return update!(state: 'pending', progress: 0) if rollbacking?

    state_finished!
  end

  def to_yaml = { one: { state: 'finished', data_version:, data: data.as_json } }
    .deep_stringify_keys
    .to_yaml

  private

  def previously_migrated_schema = self
    .class
    .finished
    .excluding(self)
    .order(created_at: :desc)
    .find_by(created_at: ..created_at)
    &.data || Schematics::Schema.new
end
