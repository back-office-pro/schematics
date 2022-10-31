# frozen_string_literal: true

module Schematics
  module SchemaDatasets
    class UpdateState
      include Interactor
      delegate :schema_dataset, to: :context, private: true

      def call
        schema_dataset.update_column(:state, 2) # rubocop:disable Rails/SkipsModelValidations
      end
    end
  end
end
