# frozen_string_literal: true

module Schematics
  class GeneratePdfJob < ApplicationJob
    def perform(user_id, model_name, resource_id)
      user = ::User.find(user_id)
      model_class = model_name.constantize
      resource = model_class.finder(resource_id)
      Resources::GenerateFile.call(
        user:,
        serializer: PdfSerializer.new(model_class, resource),
        content_type: :pdf
      )
    end
  end
end
