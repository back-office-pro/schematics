# frozen_string_literal: true

module Schematics
  class GenerateCsvTemplateJob < ApplicationJob
    queue_as :exports

    def perform(user, model_class)
      serializer = CsvTemplateSerializer.new(model_class)
      Resources::GenerateFile.call(user:, serializer:, component_method: :csv_template)
    end
  end
end
