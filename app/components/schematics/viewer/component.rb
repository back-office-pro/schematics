# frozen_string_literal: true

module Schematics
  module Viewer
    class Component < ApplicationComponent
      delegate :has_preference?, to: :helpers
      delegate :can?, to: :current_ability
      delegate :klass, to: :@resources
      delegate :entity, to: :klass
      delegate :icon, to: :entity

      class << self
        def create(resources:)
          case resources.klass.entity.viewer
          when :table
            Table::Component.new(resources: resources)
          when :grid
            Grid::Component.new(resources: resources)
          when :calendar
            Calendar::Component.new(resources: resources)
          when :tree # rubocop:disable Lint/DuplicateBranch
            Table::Component.new(resources: resources)
          when :inbox # rubocop:disable Lint/DuplicateBranch
            Table::Component.new(resources: resources)
          end
        end
      end

      def initialize(resources:)
        super
        @resources = resources
      end

      def col_preference_class(field)
        preference = "col_#{entity.name}_#{field.name}"
        return preference if has_preference?(preference)

        "#{preference} d-none"
      end
    end
  end
end
