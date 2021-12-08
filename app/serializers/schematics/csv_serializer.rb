# frozen_string_literal: true

module Schematics
  class CsvSerializer < CsvTemplateSerializer
    def initialize(model_class, resources)
      super(model_class)
      @resources = resources
    end

    def generate_file
      generate do |file|
        @resources.each do |resource|
          file << content(resource)
        end
      end
    end

    private

    def elements
      entity.listable_elements
    end

    def content(resource)
      elements.stable_sort_by(&:weight).map do |element|
        Array(element.format(resource.public_send(element.name))).join(' ')
      end
    end
  end
end
