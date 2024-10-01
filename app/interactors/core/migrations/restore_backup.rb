# frozen_string_literal: true

module Core
  module Migrations
    class RestoreBackup
      include Schematics::Progressable

      delegate :migration, to: :context, private: true
      delegate :backup, to: :migration, private: true
      delegate :attached?, to: :backup, private: true

      progressable migration: 60

      def call
        Backups::Restore.call(backup:) if attached?
      end
    end
  end
end
