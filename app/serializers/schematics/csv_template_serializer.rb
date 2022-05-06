# frozen_string_literal: true

module Schematics
  class CsvTemplateSerializer
    delegate :entity,
             :human_attribute_name,
             :human_name_plural,
             to: :@model_class,
             private: true

    def initialize(model_class)
      @model_class = model_class
    end

    def content
      generate do |file|
        2.times { file << line }
      end
    end

    def file
      @file ||= begin
        file = Tempfile.new
        file.write(content)
        file.rewind
        file
      end
    end

    def filename
      [human_name_plural.dasherize, extension].join('.')
    end

    def extension
      :csv
    end

    def content_type
      ::Mime[extension].to_s
    end

    protected

    def generate(col_sep: ',')
      CSV.generate(headers: true, col_sep:) do |file|
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

    def line
      elements
        .stable_sort_by(&:weight)
        .map(&:default)
    end
  end
end
