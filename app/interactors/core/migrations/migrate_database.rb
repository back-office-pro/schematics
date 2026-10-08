# frozen_string_literal: true

module Core
  module Migrations
    class MigrateDatabase
      include Schematics::Progressable

      delegate :fail!, to: :context, private: true
      delegate :connection_pool, :transaction, to: '::ActiveRecord::Base', private: true
      delegate :migrate, to: 'connection_pool.migration_context', private: true
      delegate :error, to: '::Rails.logger', private: true

      progressable migration: 60

      # :reek:UncommunicativeVariableName
      def call
        transaction { migrate }
      rescue StandardError => e
        error("[MigrateDatabase] #{e.message}")
        fail!
      end
    end
  end
end
