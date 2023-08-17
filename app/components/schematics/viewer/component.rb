# frozen_string_literal: true

module Schematics
  module Viewer
    class Component < ApplicationComponent
      delegate :entity, to: :model_class
      delegate :icon, to: :entity
      option :resources

      class << self
        def build(resources:, viewer:)
          case viewer
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
        preference = "col_#{entity.id}_#{field.id}"
        return preference if preferences(preference, true)

        "#{preference} d-none"
      end

      def model_class = resources.klass

      def tbody_css_classes = %w[animate__animated animate__slideInRight]
    end
  end
end
