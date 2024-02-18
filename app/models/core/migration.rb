# frozen_string_literal: true

# :reek:MissingSafeMethod
class Migration < Schematics::ApplicationRecord
  serialize :data, coder: Schematics::Schema
  attribute :data, default: -> { current_data || [] }
  validates_associated :data
  validate :quota_entities_cannot_be_exceeded
  delegate :quota_entities, to: 'Subscription.instance', private: true
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

    def current = state_finished.last

    def core = new(data: Tenant.schema.as_json, data_version: current_data_version)
  end

  def on_success(_status, options)
    migration = self.class.find(options['id'])
    return if migration.state_error?

    ::Tenant.schema = migration.data
    ::Core::Migrations::Reload.call(migration:)
  end

  def after_migrate_event
    if Tenant.backend.concurrency.zero?
      Schematics::MigrateSchemaJob.perform_later(self)
    else
      batch = Sidekiq::Batch.new
      batch.on(:success, self.class, id:)
      batch.jobs do
        Schematics::MigrateSchemaJob.perform_later(self)
      end
    end
  end

  alias after_rollback_event after_migrate_event

  memoize def migrator
    return Schematics::Migrator.new(previously_migrated_schema, data) if state_rollbacking?

    Schematics::Migrator.new(data, previously_migrated_schema)
  end

  def commit_message
    return "Rollback v#{data_version} (core v#{Schematics::VERSION})" if state_rollbacking?

    "Migration v#{data_version} (core v#{Schematics::VERSION})"
  end

  # :reek:ControlParameter
  def finalize!(failure)
    return state_error! if failure
    return update!(state: STATE_STATE_IN_PROGRESS, progress: 0) if state_rollbacking?

    state_finished!
  end

  def to_yaml = { one: { state: STATE_STATE_FINISHED, data_version:, data: data.as_json } }
    .deep_stringify_keys
    .to_yaml

  private

  def quota_entities_cannot_be_exceeded
    return unless data
    return if data_size <= quota_entities

    errors.add(:base, :too_many_entities, data_size:, quota_entities:)
  end

  def data_size = data
    .entities
    .reject(&:core?) # rubocop:disable Performance/Count
    .size

  def previously_migrated_schema = self
    .class
    .state_finished
    .excluding(self)
    .order(created_at: :desc)
    .find_by(created_at: ..created_at)
    &.data || Schematics::Schema.new
end
