# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

module Core
  module Backups
    class Restore
      include Interactor

      delegate :root, :env, to: '::Rails', private: true
      delegate :backup, :clean, to: :context, private: true
      delegate :disconnect!, to: 'ActiveRecord::Base.connection_pool', private: true
      delegate :current_database,
               :adapter_name,
               to: 'ActiveRecord::Base.lease_connection',
               private: true

      before :disconnect!

      def call
        backup.open { system command(it.path).compact.join(' ') }
      end

      private

      def command(filepath)
        case adapter_name
        when 'SQLite'
          [("rm #{db_path} &&" if clean), "gunzip -c #{filepath} | sqlite3 #{db_path}"]
        when 'PostgreSQL'
          ['pg_restore -v', ('-c' if clean), '-d', current_database, filepath]
        end
      end

      def db_path = root.join('storage', "#{env}.sqlite3")
    end
  end
end
