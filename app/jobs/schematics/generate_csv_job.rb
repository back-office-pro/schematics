# frozen_string_literal: true

module Schematics
  class GenerateCsvJob < ApplicationJob
    def perform(user_id, model_name, resource_ids, dropdown)
      user = ::User.find(user_id)
      serializer = CsvSerializer.new(model_name.constantize.find(resource_ids), user.preferences)
      Resources::GenerateFile.call(user:, serializer:, dropdown:)
    end
  end
end
