# frozen_string_literal: true

module MainApp
  module SchemaDataset
    extend ActiveSupport::Concern

    class_methods do
      def current
        migrated
          .order(created_at: :desc)
          .first
      end
    end

    def after_migrate
      Schematics::MigrateSchemaJob.perform_later(data)
    end

    def data
      super&.map(&:deep_symbolize_keys)
    end
  end
end
