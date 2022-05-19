# frozen_string_literal: true

module Schematics
  class GenerateCsvJob < ApplicationJob
    def perform(user_id, model_name, resource_ids, dropdown)
      Resources::GenerateFile.call(
        user: ::User.find(user_id),
        serializer: CsvSerializer.new(model_name.constantize.find(resource_ids), user.preferences),
        dropdown:
      )
    end
  end
end
