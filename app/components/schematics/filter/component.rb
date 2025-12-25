# Copyright © 2025 Dev & Software. All rights reserved.
#
# THIS SOFTWARE IS PROPRIETARY AND CONFIDENTIAL. UNAUTHORIZED COPYING, DISTRIBUTION, MODIFICATION,
# REVERSE ENGINEERING, OR DISCLOSURE IS STRICTLY PROHIBITED.
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT
# NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE, AND
# NONINFRINGEMENT.
# IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES, OR OTHER
# LIABILITY ARISING FROM, OUT OF, OR IN CONNECTION WITH THE SOFTWARE OR ITS USE.

# frozen_string_literal: true

module Schematics
  module Filter
    class Component < ApplicationComponent
      delegate :preferences, to: :current_user, private: true
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
        .humanize(capitalize: false)

      def col_preference_class(field)
        preference = "col_#{entity.id}_#{field.id}"
        return preference if preferences.fetch(preference, true)

        "#{preference} d-none"
      end

      def css_classes = class_names(
        'form-control',
        'rounded',
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
