# frozen_string_literal: true

module Schematics
  module Filter
    class Component < ApplicationComponent
      delegate :entity, to: :@model_class
      delegate :preferences, to: :helpers

      class << self
        def build(field:, model_class:)
          case field
          when Attributes::Boolean, Virtuals::Comparison
            Checkbox::Component.new(field:, model_class:)
          when Behaviours::Rangeable
            Range::Component.new(field:, model_class:)
          when Behaviours::Enumerable
            Dropdown::Component.new(field:, model_class:)
          else
            Typeahead::Component.new(field:, model_class:)
          end
        end
      end

      def initialize(field: nil, model_class: nil)
        super
        @field = field
        @model_class = model_class
      end

      def name
        @field.try(:name) || @field
      end

      def filter_name
        "filter[#{name}]"
      end

      def value
        params.dig(:filter, name)
      end

      def active?
        value.present?
      end

      def attribute_name
        @model_class.human_attribute_name(name).downcase
      end

      def col_preference_class(field)
        preference = "col_#{entity.table_name}_#{field.name}"
        return preference if preferences(preference, true)

        "#{preference} d-none"
      end
    end
  end
end
