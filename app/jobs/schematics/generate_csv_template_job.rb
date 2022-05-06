# frozen_string_literal: true

module Schematics
  class GenerateCsvTemplateJob < ApplicationJob
    def perform(user_id, model_name)
      user = ::User.find(user_id)
      model_class = model_name.constantize
      serializer = CsvTemplateSerializer.new(model_class)
      Resources::GenerateFile.call(
        user:,
        serializer:,
        component_method: :csv_template
      )
    end
  end
end
