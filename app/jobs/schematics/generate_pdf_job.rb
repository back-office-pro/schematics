# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

module Schematics
  class GeneratePDFJob < ApplicationJob
    limits_concurrency key: ->(user, *) { user }
    queue_as :default

    def perform(user, url_options, resource)
      serializer = PDFSerializer.new(resource, url_options)
      Resources::GenerateFile.call(user:, serializer:)
    end
  end
end
