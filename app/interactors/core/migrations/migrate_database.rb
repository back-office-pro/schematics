# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

module Core
  module Migrations
    class MigrateDatabase
      include Schematics::Progressable

      delegate :fail!, to: :context, private: true
      delegate :connection_pool, :transaction, to: '::ActiveRecord::Base', private: true
      delegate :migrate, to: 'connection_pool.migration_context', private: true

      progressable migration: 55

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
