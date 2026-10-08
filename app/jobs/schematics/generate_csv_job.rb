# frozen_string_literal: true

module Schematics
  class GenerateCSVJob < ApplicationJob
    limits_concurrency key: ->(*args) { args }, on_conflict: :discard
    queue_as :default

    def perform(user, resources, dropdown)
      return unless ::Configuration.license.active?

      serializer = CSVSerializer.new(resources, user.preferences)
      Resources::GenerateFile.call(user:, serializer:, dropdown:)
    end
  end
end
