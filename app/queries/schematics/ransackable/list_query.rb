# frozen_string_literal: true

module Schematics
  module Ransackable
    class ListQuery < ApplicationQuery
      include Sortable
      include Filterable

      # :reek:ControlParameter
      def call(filter_params, ability, sort_params = nil)
        preload_all
          .ransack(parse_filter_params(filter_params))
          .tap { _1.sorts = parse_sort_params(sort_params) }
          .result(distinct: true)
          .left_joins(entity.joins)
          .accessible_by(ability)
          .load_async
          .select(
            arel_table[::Arel.star],
            *entity.virtuals.map(&:to_sql),
            *filter_params
              .keys
              .map(&entity.method(:find_field_by_name))
              .grep(Behaviours::Translatable)
              .select(&:translated?)
              .map(&method(:i18_field_value))
          )
      end

      protected

      def i18_field_value(field)
        return if I18n.locale == I18n.default_locale

        "#{entity.class_name}_#{field.name}_#{I18n.locale}_#{field.preload}.value"
      end
    end
  end
end
