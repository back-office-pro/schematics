# frozen_string_literal: true

module Schematics
  class GenerateCSVJob < ApplicationJob
    queue_as :exports

    def perform(user, resources, dropdown)
      serializer = CSVSerializer.new(resources, user.preferences)
      Resources::GenerateFile.call(user:, serializer:, dropdown:)
    end
  end
end
