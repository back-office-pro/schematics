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

module Core
  module Imports
    class ReadData
      include Schematics::Progressable

      VALUES_SEPARATOR = ';'

      delegate :import, to: :context, private: true
      delegate :model_class, :data, :model, to: :import, private: true
      delegate :entity, :i18n_scope, to: :model_class, private: true
      delegate :fillable_elements, to: :entity, private: true

      progressable import: 10

      before { context.data = Concurrent::Hash.new }

      def call = data
        .each
        .with_index(1) { |row, line| context.data[line] = convert_row(row.to_h.compact) }

      private

      def convert_row(row)
        row.to_h do |key, value|
          [
            transform_key(key) || key.parameterize(separator: '_').to_sym,
            transform_value(transform_key(key), value) || value
          ]
        end
      end

      def transform_key(key)
        attributes_translations
          &.invert
          &.dig(key)
      end

      def attributes_translations
        ::I18n
          .t(model.underscore.to_sym, scope: [i18n_scope, :attributes])
          .transform_values { _1.try(:fetch, :other) || _1 }
      end

      def transform_value(key, value) # rubocop:disable Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity
        return unless value

        case field = fillable_elements.find { _1.name == key.to_s }
        when Schematics::Associations::HasAndBelongsToMany
          value
            .split(VALUES_SEPARATOR)
            .map(&method(:association_value).curry.call(field))
        when Schematics::Attributes::Association
          association_value(field, value)
        when Schematics::Attributes::Enum
          enums_translations
            &.dig(field.name.to_sym)
            &.invert
            &.dig(value)
        when Schematics::Attributes::Country
          ISO3166::Country
            .find_country_by_any_name(value)
            &.alpha2
        when Schematics::Attributes::Mime
          Mime[value.downcase].to_s
        when Schematics::Attributes::Array, Schematics::Attributes::Flag
          value.split(VALUES_SEPARATOR)
        end
      end

      def association_value(field, value)
        case field.descriptor.field
        when Schematics::Behaviours::Translatable
          field
            .model_class
            .i18n
            .eager_load(field.descriptor.joins)
            .find_by(field.descriptor.name => value)
        else
          field
            .model_class
            .eager_load(field.descriptor.joins)
            .find_by("#{field.descriptor.to_sql} = ?", value)
        end
      end

      def enums_translations
        ::I18n.t(model.underscore.to_sym, scope: [i18n_scope, :enums])
      end
    end
  end
end
