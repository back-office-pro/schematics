# frozen_string_literal: true

module Schematics
  class GeneratePdfJob < ApplicationJob
    def perform(model_name, resource_id, filepath)
      resource = model_name.constantize.finder(resource_id)
      File.open(filepath, 'wb') { _1 << PdfSerializer.new(model_name, resource).generate_file }
      DeleteTempFileJob.set(wait: 5.minutes).perform_later(filepath)
    end
  end
end
