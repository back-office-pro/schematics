# frozen_string_literal: true

module Schematics
  class GenerateCsvTemplateJob < ApplicationJob
    def perform(model_name)
      model_class = model_name.constantize
      CsvTemplateSerializer.new(model_class).generate_file
    end
  end
end
