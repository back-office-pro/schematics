# frozen_string_literal: true

module Core
  module SchemaDatasets
    class UpdateState
      include Interactor

      delegate :schema_dataset, to: :context, private: true
      delegate :state_migrated!, :persisted?, to: :schema_dataset, private: true

      def call
        PaperTrail.request(enabled: false) do
          persisted? && state_migrated!
        end
      end
    end
  end
end
