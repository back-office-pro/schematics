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

      def read_on_controller = !Rails.env.test?

      def data = ::OpenApi
        .generate_docs(read_on_controller)
        .fetch(:open_api)
    end
  end
end
