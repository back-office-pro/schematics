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

        def interpolate(element)
          element
            .to_spec
            .gsub(/\*\*(.+)\*\*/, '<b>\1</b>')
            .gsub(/\*(.+)\*/, '<i>\1</i>')
            .gsub(/`(.+)`/, '<code>\1</code>')
        end

        def render?
          entities.any?
        end
      end
    end
  end
end
