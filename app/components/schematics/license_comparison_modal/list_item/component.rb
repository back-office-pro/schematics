# frozen_string_literal: true

module Schematics
  module LicenseComparisonModal
    module ListItem
      class Component < ApplicationComponent
        option :model_class, optional: true
        option :icon, optional: true
        option :text, optional: true
        option :count, default: -> { '∞' }

        def icon
          super || model_class.entity.icon
        end

        def text
          super || model_class
            .human_name(count:)
            .then_tap { it.capitalize if zero? }
        end

        def css_class
          'text-decoration-line-through' if zero?
        end

        def zero?
          count == 0 # rubocop:disable Style/NumericPredicate
        end
      end
    end
  end
end
