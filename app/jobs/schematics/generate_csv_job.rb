# frozen_string_literal: true

module Schematics
  class GenerateCsvJob < ApplicationJob
    def perform(user_id, model_name, resource_ids, dropdown)
      user = ::User.find(user_id)
      resources = model_name.constantize.find(resource_ids)
      serializer = CsvSerializer.new(resources, user.preferences)
      Resources::GenerateFile.call(user:, serializer:, extension: :csv, dropdown:)
    end
  end
end
