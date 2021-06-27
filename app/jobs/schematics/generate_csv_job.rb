# frozen_string_literal: true

module Schematics
  class GenerateCsvJob < ApplicationJob
    def perform(model_name, resource_ids, filepath)
      model_class = model_name.constantize
      resources = model_class.find(resource_ids)
      File.write(filepath, CsvSerializer.new(model_class, resources).generate_file)
      DeleteTempFileJob.set(wait: 5.minutes).perform_later(filepath)
    end
  end
end
