# frozen_string_literal: true

module Core
  module SchemaDatasets
    class GenerateDocumentation
      include Interactor
      delegate :schema_dataset, to: :context, private: true

      def call
        PaperTrail.request(enabled: false) do
          ::Documentation.create!(app_version:)
        end
      end

      private

      def app_version
        schema_dataset.data_version || ::SchemaDataset.current_data_version
      end
    end
  end
end
