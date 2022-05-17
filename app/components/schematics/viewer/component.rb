# frozen_string_literal: true

module Schematics
  module Viewer
    class Component < ApplicationComponent
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

      def initialize(resources:)
        super
        @resources = resources
      end

      protected

      def model_class
        @resources.try(:klass) || @resources.first.class
      end

      def col_preference_class(field)
        preference = "col_#{entity.table_name}_#{field.name}"
        return preference if preferences(preference, true)

        "#{preference} d-none"
      end

      def tbody_css_classes
        %w[animate__animated animate__slideInRight]
      end
    end
  end
end
