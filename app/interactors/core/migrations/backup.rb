# frozen_string_literal: true

module Core
  module Migrations
    class Backup
      include Schematics::Progressable

      delegate :migration_context, to: 'ActiveRecord::Base.connection_pool', private: true
      delegate :needs_migration?, to: :migration_context, private: true
      delegate :migration, to: :context, private: true

      progressable migration: 50

      def call
        return unless needs_migration?

        IO.popen(command) do |io|
          migration.file.attach(**Backups::Create.call.to_h)
        end
      end
    end
  end
end
