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
  module Migrations
    class MigrateDatabase
      include Schematics::Progressable

      delegate :fail!, to: :context, private: true
      delegate :connection_pool, :transaction, to: '::ActiveRecord::Base', private: true
      delegate :migrate, to: 'connection_pool.migration_context', private: true

      progressable migration: 60

      # :reek:UncommunicativeVariableName
      def call
        transaction { migrate }
      rescue StandardError => e
        Rollbar.error(e, '[Migration] MigrateDatabase error')
        fail!
      end
    end
  end
end
