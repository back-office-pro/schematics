# frozen_string_literal: true

module Schematics
  module Viewer
    class Component < ApplicationComponent
      delegate :entity, to: :model_class
      delegate :icon, to: :entity
      option :resources

      class << self
        def build(resources:, viewer:)
          Viewer.const_get(viewer.to_s.camelize)::Component.new(resources:)
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

      def elements = entity
        .listable_elements
        .stable_sort_by(&:weight)
    end
  end
end
