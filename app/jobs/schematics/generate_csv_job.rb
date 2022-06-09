# frozen_string_literal: true

module Schematics
  class GenerateCsvJob < ApplicationJob
    def perform(user, resources, dropdown)
      serializer = CsvSerializer.new(resources, user.preferences)
      Resources::GenerateFile.call(user:, serializer:, dropdown:)
    end
  end
end
