module Schematics
  module Filterable
    extend ActiveSupport::Concern

    def filter_params
      return {} unless params.key?(:filter)
      params
        .require(:filter)
        .permit(permitted_filters)
        .to_h
        .deep_symbolize_keys
        .transform_values(&method(:cast_filter_value))
    end

    private

    def permitted_filters
      entity.searchable_elements
            .reject_is_a?(Schematics::Behaviours::Rangeable)
            .map(&:name)
            .map(&:to_sym)
            .append(:with_deleted) + entity
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
        { gte: gte.to_f }
      in lte:
        { lte: lte.to_f }
      else
        /.*#{value.parameterize(separator: ' ')}.*/
      end
    end
  end
end
