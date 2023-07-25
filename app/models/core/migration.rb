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
  end

  def after_migrate
    Schematics::MigrateSchemaJob.wait_for(self)
    Schematics::MigrateSchemaJob.perform_later(self)
  end

  memoize def migrator = Schematics::Migrator.new(data, Tenant.schema)

  def dump! = Rails
    .root
    .join('spec/fixtures/migrations.yml')
    .write(fixture)

  private

  def fixture = { one: { state:, data_version:, data: data.as_json } }
    .deep_stringify_keys
    .to_yaml
end
