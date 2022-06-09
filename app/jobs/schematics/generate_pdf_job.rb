# frozen_string_literal: true

module Schematics
  class GeneratePdfJob < ApplicationJob
    def perform(user, resource)
      serializer = PdfSerializer.new(resource)
      Resources::GenerateFile.call(user:, serializer:)
    end
  end
end
