# frozen_string_literal: true

module Core
  module Migrations
    class GenerateBackup
      include Schematics::Progressable

      delegate :migration_context, to: 'ActiveRecord::Base.connection_pool', private: true
      delegate :needs_migration?, to: :migration_context, private: true
      delegate :migration, to: :context, private: true
      delegate :state_rollbacking?, to: :migration, private: true

      progressable migration: 50

      def call
        return if state_rollbacking?
        return unless needs_migration?

        migration.backup.attach(file)
      end

      private

      def file = Backups::Create
        .call(tables:)
        .file

      def tables = migration
        .migrator_old_and_changed_entities
        .map(&:table_name)
    end
  end
end
