# frozen_string_literal: true

module Core
  module Backups
    class Restore
      include Interactor

      delegate :current_database, to: 'ActiveRecord::Base.lease_connection', private: true
      delegate :disconnect!, to: 'ActiveRecord::Base.connection_pool', private: true
      delegate :backup, :clean, to: :context, private: true

      before :disconnect!

      def call
        backup.open { system command(_1) }
      end

      private

      def command(file)
        [
          'pg_restore', # TODO
          '-v',
          ('-c' if clean),
          '-d',
          current_database,
          file.path
        ].compact.join(' ')
      end
    end
  end
end
