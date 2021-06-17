# frozen_string_literal: true

module Schematics
  class CsvSerializer < CsvTemplateSerializer
    delegate :listable_elements, to: :entity

    def initialize(model_class, resources)
      super(model_class)
      @resources = resources
    end

    def generate_file(filepath)
      generate(filepath) do |file|
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
      listable_elements.stable_sort_by(&:weight).map do |element|
        Array.wrap(element.format(resource.instance_eval(element.name))).join(' ')
      end
    end
  end
end
