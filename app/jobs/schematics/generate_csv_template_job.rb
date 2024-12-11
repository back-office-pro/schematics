# frozen_string_literal: true

module Schematics
  class GenerateCSVTemplateJob < ApplicationJob
    limits_concurrency key: ->(user, *) { user }
    queue_as :exports

    def perform(user, model_class)
      serializer = CSVTemplateSerializer.new(model_class)
      Resources::GenerateFile.call(user:, serializer:, component_method: :csv_template)
    end
  end
end
