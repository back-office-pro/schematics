# Copyright © 2025 Dev & Software. All rights reserved.
#
# THIS SOFTWARE IS PROPRIETARY AND CONFIDENTIAL. UNAUTHORIZED COPYING, DISTRIBUTION, MODIFICATION,
# REVERSE ENGINEERING, OR DISCLOSURE IS STRICTLY PROHIBITED.
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT
# NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE, AND
# NONINFRINGEMENT.
# IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES, OR OTHER
# LIABILITY ARISING FROM, OUT OF, OR IN CONNECTION WITH THE SOFTWARE OR ITS USE.

# frozen_string_literal: true

module Core
  module Backups
    class Restore
      include Interactor

      delegate :root, :env, :configuration, to: '::Rails', private: true
      delegate :database_configuration, to: :configuration, private: true
      delegate :backup, :clean, to: :context, private: true
      delegate :disconnect!, to: 'ActiveRecord::Base.connection_pool', private: true
      delegate :current_database,
               :adapter_name,
               to: 'ActiveRecord::Base.lease_connection',
               private: true

      before :disconnect!

      def call
        backup.open { system command(_1.path).compact.join(' ') }
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

      def db_path = root.join(database_configuration.dig(env, 'primary', 'database'))
    end
  end
end
