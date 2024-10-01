# frozen_string_literal: true

module Core
  module Migrations
    class GenerateBackup
      include Schematics::Progressable

      delegate :migration_context, to: 'ActiveRecord::Base.connection_pool', private: true
      delegate :needs_migration?, to: :migration_context, private: true
      delegate :migration, to: :context, private: true
      delegate :migrator_clean_commands, to: :migration, private: true

      progressable migration: 50

      def call
        return if tables.empty?
        return unless needs_migration?

        migration.backup.attach(file)
      end

      private

      def file = Backups::Create
        .call(tables:)
        .file

      def join_tables = migrator_clean_commands
        .grep(Schematics::Commands::RemoveAssociation)
        .map(&:attribute)
        .map(&:join_table)

      def tables = migrator_clean_commands
        .grep(Schematics::Commands::DestroyEntity)
        .concat(migrator_clean_commands.grep(Schematics::Commands::RemoveAttribute))
        .map(&:entity)
        .map(&:table_name)
        .map(&:pluralize)
        .concat(join_tables)
    end
  end
end
