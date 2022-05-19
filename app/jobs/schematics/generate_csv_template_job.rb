# frozen_string_literal: true

module Schematics
  class GenerateCsvTemplateJob < ApplicationJob
    def perform(user_id, model_name)
      Resources::GenerateFile.call(
        user: ::User.find(user_id),
        serializer: CsvTemplateSerializer.new(model_name.constantize),
        component_method: :csv_template
      )
    end
  end
end
