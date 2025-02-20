# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

# :reek:MissingSafeMethod
module Core
  module Migration
    extend ActiveSupport::Concern

    GATEWAY = Migrations::OpenAI::ChatGPT

    prepended do
      serialize :data, coder: Schematics::Schema
      attribute :data, default: -> { current_data || [] }

      validates_associated :data
      validate :quota_entities_cannot_be_exceeded
      delegate :quota_entities, to: '::Subscription', private: true
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
    end

    class_methods do
      delegate :version, :data, to: :current, prefix: true, allow_nil: true
      delegate :business_sector, to: '::Subscription', private: true

      def current = state_finished.last

      def scheduled = state_scheduled.last

      def core = new(data: schema.as_json, version: current_version)

      def default = new(
        data: ActiveSupport::ConfigurationFile.parse(
          Schematics::Engine.root.join('db', 'seeds', 'migrations', "#{business_sector}.yml")
        )
      )

      def default_prompt = I18n.t(
        'migrations.openai.chatgpt.user',
        business_sector: ::Subscription
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
      return Schematics::Migrator.new(previously_migrated_schema, data) if state_rollbacking?

      Schematics::Migrator.new(data, previously_migrated_schema)
    end

    def commit_message = [
      ('[Rollback]' if state_rollbacking?),
      self.class.name,
      version&.to_s&.prepend('v'),
      "(core v#{Schematics::VERSION})"
    ].compact.join(' ')

    # :reek:ControlParameter
    def finalize!(failure)
      return state_error! if failure
      return update!(state: STATE_STATE_EDITING, progress: 0) if state_rollbacking?

      state_finished!
    end

    def locale
      author&.locale || ::Configuration.locale
    end

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
end
