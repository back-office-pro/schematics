# frozen_string_literal: true

module Core
  module Migrations
    class MigrateDatabase
      include Interactor

      delegate :fail!, to: :context, private: true
      delegate :connection_pool, :transaction, to: ::ActiveRecord::Base, private: true
      delegate :migrate, to: 'connection_pool.migration_context', private: true

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
