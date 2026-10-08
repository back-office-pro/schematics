# frozen_string_literal: true

module Schematics
  class GenerateCSVTemplateJob < ApplicationJob
    limits_concurrency key: ->(*args) { args }, on_conflict: :discard
    queue_as :default

    def perform(user, model_class)
      serializer = CSVTemplateSerializer.new(model_class)
      Resources::GenerateFile.call(user:, serializer:, component_method: :csv_template)
    end
  end
end
