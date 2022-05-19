# frozen_string_literal: true

module Schematics
  class GeneratePdfJob < ApplicationJob
    def perform(user_id, model_name, resource_id)
      Resources::GenerateFile.call(
        user: ::User.find(user_id),
        serializer: PdfSerializer.new(model_name.constantize.finder(resource_id))
      )
    end
  end
end
