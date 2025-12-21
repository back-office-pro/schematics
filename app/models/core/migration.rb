# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

# :reek:MissingSafeMethod
class ::Migration < Schematics::ApplicationRecord
  GATEWAY = ::Core::Migrations::OpenAI::ChatGPT

  serialize :data, coder: Schematics::Schema
  attribute :data, default: -> { current_data || [] }

  validates_associated :data

  delegate :build_commands,
           :clean_commands,
           :old_entities,
           :changed_entities,
           :new_and_changed_entities,
           :old_and_changed_entities,
           :new_schema,
           to: :migrator,
           prefix: true

  after_save_commit :prompt_data

  class << self
    delegate :version, :data, to: :current, prefix: true, allow_nil: true
    delegate :business_sector, to: '::Subscription', private: true

    def current = state_finished.last

    def scheduled = state_scheduled.last

    def core = new(data: SchemaCache.as_json, version: current_version)

    def default = new(
      data: ActiveSupport::ConfigurationFile.parse(
        Rails.root.join('db', 'seeds', 'migrations', "#{business_sector}.yml")
      )
    )

    def default_prompt = I18n.t(
      'migrations.openai.chatgpt.user',
      business_sector: Subscription
        .instance
        .business_sector_formatted
        .downcase
    )
  end

  def after_migrate_event
    Schematics::MigrateSchemaJob.perform_later(self)
  end

  def after_rollback_event
    Schematics::RollbackSchemaJob.perform_later(self)
  end

  def migrator
    if state_rollbacking?
      Schematics::Migrator.new(previously_migrated_schema, data)
    else
      Schematics::Migrator.new(data, previously_migrated_schema)
    end
  end

  # :reek:ControlParameter
  def finalize!(failure)
    return state_error! if failure
    return update!(state: self.class::STATE_STATE_EDITING, progress: 0) if state_rollbacking?

    state_finished!
  end

  def locale
    author&.locale || ::Configuration.locale
  end

  private

  def prompt_data
    Schematics::GenerateSchemaJob.perform_later(self) if prompt_previously_changed?
  end

  def previously_migrated_schema = self
    .class
    .state_finished
    .excluding(self)
    .order(created_at: :desc)
    .find_by(created_at: ..created_at)
    &.data || Schematics::Schema.new
end
