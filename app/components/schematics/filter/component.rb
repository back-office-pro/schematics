# frozen_string_literal: true

module Schematics
  module Filter
    class Component < ApplicationComponent
      delegate :entity, to: :model_class
      option :field, optional: true
      option :model_class, optional: true

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

      def active?
        value.present?
      end

      def attribute_name = model_class
        .human_attribute_name(name)
        .downcase

      def col_preference_class(field)
        preference = "col_#{entity.id}_#{field.id}"
        return preference if preferences(preference, true)

        "#{preference} d-none"
      end

      def css_classes = class_names(
        'form-control',
        'bg-transparent',
        'text-secondary',
        'fw-bold': active?
      )

      def filter_name = "#{filter_key}[#{name}]"

      def name
        field.try(:name) || field
      end

      def form = 'filters'

      def data = { action: 'change->application#submitForm' }

      def value = params.dig(filter_key, name)

      protected

      def filter_key = Ransack.options[:search_key]
    end
  end
end
