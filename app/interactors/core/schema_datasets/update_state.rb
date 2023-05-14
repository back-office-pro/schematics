# frozen_string_literal: true

module Core
  module SchemaDatasets
    class UpdateState
      include Interactor

      delegate :schema_dataset, to: :context, private: true
      delegate :persisted?, to: :schema_dataset, private: true

      def call
        return unless persisted?

        PaperTrail.request(enabled: false) do
          schema_dataset.state_migrated!
        end
      end
    end
  end
end
