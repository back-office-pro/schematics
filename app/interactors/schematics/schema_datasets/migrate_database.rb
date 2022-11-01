# frozen_string_literal: true

module Schematics
  module SchemaDatasets
    class MigrateDatabase
      include Interactor
      delegate :migration_context, to: 'ActiveRecord::Base.connection', private: true
      delegate :migrate, to: :migration_context, private: true

      def call = migrate
    end
  end
end
