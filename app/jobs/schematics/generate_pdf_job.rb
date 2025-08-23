# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

module Schematics
  class GeneratePDFJob < ApplicationJob
    limits_concurrency key: ->(*args) { args }, on_conflict: :discard
    queue_as :default

    def perform(user, resource)
      serializer = PDFSerializer.new(resource)
      Resources::GenerateFile.call(user:, serializer:)
    end
  end
end
