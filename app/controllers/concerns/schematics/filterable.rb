# frozen_string_literal: true

module Schematics
  module Filterable
    extend ActiveSupport::Concern

    def filter_params
      return {} unless params.key?(:filter)

      filter_params_to_h
        .deep_symbolize_keys
        .transform_values(&method(:cast_filter_value))
    end

    private

    def filter_params_to_h
      params
        .require(:filter)
        .permit(permitted_filters)
        .to_h
    end

    def permitted_filters
      entity.searchable_elements
            .reject_is_a?(Schematics::Behaviours::Rangeable)
            .map(&:name)
            .map(&:to_sym)
            .push(:with_deleted) + entity
                                   .rangeable_elements
                                   .map { |element| { element.name.to_sym => %i[gte lte] } }
    end

    def cast_filter_value(value)
      case value
      in 'true'
        true
      in 'false'
        false
      in gte:
        { gte: cast_comparison(gte) }
      in lte:
        { lte: cast_comparison(lte) }
      else
        { ilike: "%#{value}%" }
      end
    end

    def cast_comparison(value)
      return value.to_date if value.match?(/\d{4}-\d{2}-\d{2}/)

      value.to_f
    end
  end
end
