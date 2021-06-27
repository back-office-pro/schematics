# frozen_string_literal: true

module Schematics
  class GenerateCsvTemplateJob < ApplicationJob
    def perform(model_name, filepath)
      model_class = model_name.constantize
      File.write(filepath, CsvTemplateSerializer.new(model_class).generate_file)
      DeleteTempFileJob.set(wait: 5.minutes).perform_later(filepath)
    end
  end
end
