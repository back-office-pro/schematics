# frozen_string_literal: true

module Schematics
  class GeneratePDFJob < ApplicationJob
    queue_as :exports

    def perform(user, resource)
      serializer = PDFSerializer.new(resource)
      Resources::GenerateFile.call(user:, serializer:)
    end
  end
end
