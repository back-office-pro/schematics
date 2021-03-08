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
        .transform_values { |value| value.try(:regexize) || value }
    end

    private

    def searchable_filters
      (entity.searchable_elements - entity.rangeable_fields)
        .map(&:name)
        .map(&:to_sym)
    end

    def rangeable_filters
      entity
        .rangeable_fields
        .map { |field| { field.name.to_sym => %i[gte lte] } }
    end

    def permitted_filters
      (searchable_filters + rangeable_filters) << :with_deleted
    end
  end
end
