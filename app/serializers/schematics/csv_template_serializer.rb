# frozen_string_literal: true

module Schematics
  class CsvTemplateSerializer
    delegate :entity, :human_attribute_name, to: :@model_class, private: true

    def initialize(model_class)
      @model_class = model_class
    end

    def generate_file
      generate do |file|
        2.times { file << content }
      end
    end

    protected

    def generate(separator: ',')
      CSV.generate(headers: true, col_sep: separator) do |file|
        file << headers
        yield file
      end
    end

    def elements
      entity.fillable_elements
    end

    def headers
      elements
        .stable_sort_by(&:weight)
        .map(&:name)
        .map { |name| human_attribute_name(name) }
    end

    def content
      elements
        .stable_sort_by(&:weight)
        .map(&:default)
    end
  end
end
