# frozen_string_literal: true

module Schematics
  class CsvSerializer < CsvTemplateSerializer
    def initialize(resources, preferences)
      super(resources.first.class)
      @resources = resources
      @preferences = preferences
    end

    def content
      generate do |file|
        @resources.each do |resource|
          file << line(resource)
        end
      end
    end

    private

    def elements = entity
      .listable_elements
      .select { @preferences.fetch("col_#{_1.entity.table_name}_#{_1.name}", true) }

    def line(resource)
      elements.stable_sort_by(&:weight).map do |element|
        Array(element.format(resource.public_send(element.name))).join(' ')
      end
    end
  end
end
