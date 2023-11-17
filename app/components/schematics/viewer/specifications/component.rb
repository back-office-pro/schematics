# frozen_string_literal: true

module Schematics
  module Viewer
    module Specifications
      class Component < ApplicationComponent
        option :schema

        def title = t('.title')

        def icon = :book

        def entities = schema
          .entities
          .reject(&:core?)
          .sort_by(&:name)

        def render?
          entities.any?
        end
      end
    end
  end
end
