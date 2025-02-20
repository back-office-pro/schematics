# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

module Schematics
  class GenerateCSVJob < ApplicationJob
    limits_concurrency key: ->(user, *) { user }
    queue_as :default

    def perform(user, resources, dropdown)
      serializer = CSVSerializer.new(resources, user.preferences)
      Resources::GenerateFile.call(user:, serializer:, dropdown:)
    end
  end
end
