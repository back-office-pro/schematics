# frozen_string_literal: true

module Schematics
  class CsvTemplateSerializer
    delegate :entity, :human_attribute_name, to: :@model_class, private: true
    delegate :fillable_elements, to: :entity

    def initialize(model_class)
      @model_class = model_class
    end

    def file(separator: ',')
      CSV.generate(headers: true, col_sep: separator) do |file|
        file << headers
        2.times { file << content }
      end
    end

    private

    def headers
      fillable_elements
        .stable_sort_by(&:weight)
        .map(&:name)
        .map { |name| human_attribute_name(name) }
    end

    def content
      fillable_elements
        .stable_sort_by(&:weight)
        .map(&:default)
    end
  end
end
