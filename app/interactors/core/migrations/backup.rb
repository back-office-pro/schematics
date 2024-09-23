# frozen_string_literal: true

module Core
  module Migrations
    class Backup
      include Schematics::Progressable

      delegate :migration_context, to: 'ActiveRecord::Base.connection_pool', private: true
      delegate :needs_migration?, to: :migration_context, private: true
      delegate :migration, to: :context, private: true
      delegate :state_rollbacking?, to: :migration, private: true

      progressable migration: 50

      def call
        return if state_rollbacking?
        return unless needs_migration?

        migration.backup.attach(**Backups::Create.call.to_h)
      end
    end
  end
end
