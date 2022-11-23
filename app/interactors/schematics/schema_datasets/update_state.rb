# frozen_string_literal: true

module Schematics
  module SchemaDatasets
    class UpdateState
      include Interactor
      delegate :schema_dataset, to: :context, private: true

      def call
        PaperTrail.request(enabled: false) do
          schema_dataset.state_migrated!
        end
      end
    end
  end
end
