# frozen_string_literal: true

module Schematics
  module SchemaDatasets
    class MigrateDatabase
      include Interactor

      delegate :needs_migration?, to: :migration_context, private: true
      delegate :id, to: :@schema_dataset, private: true
      delegate :current_database,
               :migration_context,
               to: 'ActiveRecord::Base.connection',
               private: true

      before do
        @schema_dataset = context.schema_dataset
      end

      def call
        return unless needs_migration?

        system "pg_dump -F t #{current_database} > migration_#{id}.tar"
        system "rails db:migrate > log/migration_#{id}.log"
      end
    end
  end
end
