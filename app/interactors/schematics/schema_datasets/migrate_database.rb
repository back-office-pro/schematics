# frozen_string_literal: true

module Schematics
  module SchemaDatasets
    class MigrateDatabase
      include Interactor

      delegate :schema_dataset, to: :context, private: true
      delegate :needs_migration?, to: :migration_context, private: true
      delegate :id, to: :schema_dataset, private: true
      delegate :app_env, to: 'Schematics::Engine', private: true
      delegate :migration_context, to: 'ActiveRecord::Base.connection', private: true

      def call
        return unless needs_migration?

        Application::ActiveStorage::Backup.call
        system "RAILS_ENV=#{app_env} rails db:migrate > log/migration_#{id}.log"
      end
    end
  end
end
