# frozen_string_literal: true

module Schematics
  module SchemaDatasets
    class WriteDocs
      include Interactor

      before do
        @schema_dataset = context.schema_dataset
      end

      def call
        @schema_dataset.update_column(:state, 2) # rubocop:disable Rails/SkipsModelValidations
        system 'rails schematics:docs:generate'
      end
    end
  end
end
