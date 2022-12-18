# frozen_string_literal: true

module Schematics
  module Filterable
    extend ActiveSupport::Concern

    def log_search!
      return unless params.key?(filter_key)

      current_user
        .searches
        .create!(model: model_class, filters: filter_params_to_h)
    end

    def filter_params
      return {} unless params.key?(filter_key)

      filter_params_to_h
        .deep_symbolize_keys
        .transform_keys(&method(:convert_key_to_search_query))
        .transform_values(&method(:cast_filter_value))
    end

    private

    def filter_key = Ransack.options[:search_key]

    def convert_key_to_search_query(key)
      entity
        .find_field_by_name(key)
        .search_query
    end

    def cast_comparison(value)
      return value.to_date if value.match?(/\d{4}-\d{2}-\d{2}/)

      value.to_f
    end

    def cast_filter_value(value)
      case value
      in 'true'
        true
      in 'false'
        false
      in gte:
        cast_comparison(gte)
      in lte:
        cast_comparison(lte)
      else
        value
      end
    end

    def filter_params_to_h = params
      .require(filter_key)
      .permit(permitted_filters)
      .to_h
      .compact_blank

    def permitted_filters = entity
      .searchable_elements
      .reject_is_a?(Schematics::Behaviours::Rangeable)
      .map(&:name)
      .map(&:to_sym)
      .push(:with_deleted)
      .concat(entity.rangeable_elements.map { { _1.name.to_sym => %i[gte lte] } })
  end
end
