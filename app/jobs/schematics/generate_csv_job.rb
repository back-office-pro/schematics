# frozen_string_literal: true

module Schematics
  class GenerateCsvJob < ApplicationJob
    def perform(user_id, model_name, resource_ids, dropdown)
      user = ::User.find(user_id)
      model_class = model_name.constantize
      resources = model_class.find(resource_ids)
      Resources::GenerateFile.call(
        user:,
        serializer: CsvSerializer.new(model_class, resources, user.preferences),
        content_type: :csv,
        dropdown:
      )
    end
  end
end
