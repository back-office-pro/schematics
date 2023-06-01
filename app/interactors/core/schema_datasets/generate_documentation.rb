# frozen_string_literal: true

module Core
  module SchemaDatasets
    class GenerateDocumentation
      include Interactor

      def call
        PaperTrail.request(enabled: false) do
          ::Documentation.create!
        end
      end
    end
  end
end
