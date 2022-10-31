# frozen_string_literal: true

module Schematics
  module SchemaDatasets
    class WriteDocs
      include Interactor

      def call
        PaperTrail.request(enabled: false) do
          ::Documentation.instance.update!(data:)
        end
      end

      private

      def data = ::OpenApi
        .generate_docs(true)
        .fetch(:open_api)
    end
  end
end
