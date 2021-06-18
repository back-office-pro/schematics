# frozen_string_literal: true

module Schematics
  class GenerateCsvTemplateJob < ApplicationJob
    def perform(model_name, fingerprint)
      model_class = model_name.constantize
      filepath = Rails.root.join('tmp', "#{fingerprint}.csv").to_s
      File.write(filepath, CsvTemplateSerializer.new(model_class).generate_file)
      DeleteTempFileJob.set(wait: 5.minutes).perform_later(filepath)
    end
  end
end
