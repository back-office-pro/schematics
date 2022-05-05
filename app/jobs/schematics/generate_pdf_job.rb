# frozen_string_literal: true

module Schematics
  class GeneratePdfJob < ApplicationJob
    def perform(user_id, model_name, resource_id)
      user = ::User.find(user_id)
      resource = model_name.constantize.finder(resource_id)
      serializer = PdfSerializer.new(resource)
      Resources::GenerateFile.call(user:, serializer:, extension: :pdf)
    end
  end
end
