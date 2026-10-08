# frozen_string_literal: true

module Core
  module Migrations
    class RestoreBackup
      include Schematics::Progressable

      delegate :migration, to: :context, private: true
      delegate :backup, to: :migration, private: true
      delegate :attached?, to: :backup, private: true
      delegate :error, to: '::Rails.logger', private: true

      progressable migration: 60

      # :reek:UncommunicativeVariableName
      def call
        Backups::Restore.call(backup:) if attached?
      rescue ActiveStorage::FileNotFoundError => e
        error("[RestoreBackup] #{e.message}")
      end
    end
  end
end
