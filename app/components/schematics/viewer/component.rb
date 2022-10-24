# frozen_string_literal: true

module Schematics
  module Viewer
    class Component < ApplicationComponent
      option :resources
      delegate :entity, to: :model_class
      delegate :icon, to: :entity

      class << self
        def build(resources:)
          case resources.klass.entity.viewer
          when :table
            Table::Component.new(resources:)
          when :grid
            Grid::Component.new(resources:)
          when :calendar
            Calendar::Component.new(resources:)
          end
        end
      end

      protected

      def col_preference_class(field)
        preference = "col_#{entity.table_name}_#{field.name}"
        return preference if preferences(preference, true)

        "#{preference} d-none"
      end

      def model_class = resources.klass

      def tbody_css_classes = %w[animate__animated animate__slideInRight]
    end
  end
end
