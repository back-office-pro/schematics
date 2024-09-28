# frozen_string_literal: true

module Core
  module Migrations
    class RestoreBackup
      include Schematics::Progressable

      delegate :migration, to: :context, private: true
      delegate :state_rollbacking?, :backup, to: :migration, private: true
      delegate :attached?, to: :backup, private: true

      progressable migration: 60

      def call
        return unless state_rollbacking?
        return unless attached?

        Backups::Restore.call(backup:)
      end
    end
  end
end
