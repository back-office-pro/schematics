# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

module Schematics
  class CSVSerializer < CSVTemplateSerializer
    def initialize(resources, preferences)
      super(resources.first.class)
      @resources = resources
      @preferences = preferences
    end

    memoize def content
      generate do |file|
        @resources.each do |resource|
          file << line(resource)
        end
      end
    end

    private

    def elements = entity
      .listable_elements
      .select { @preferences.fetch("col_#{it.entity.id}_#{it.id}", true) }

    def line(resource)
      elements.stable_sort_by(&:weight).map do |element|
        Array(element.format(resource.public_send(element.name))).join(' ')
      end
    end
  end
end
