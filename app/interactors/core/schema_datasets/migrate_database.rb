# frozen_string_literal: true

module Core
  module SchemaDatasets
    class MigrateDatabase
      include Interactor

      delegate :fail!, to: :context, private: true
      delegate :connection, :transaction, to: ::ActiveRecord::Base, private: true
      delegate :migrate, to: 'connection.migration_context', private: true

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
