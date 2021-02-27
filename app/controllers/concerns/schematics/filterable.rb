module Schematics
  module Filterable
    extend ActiveSupport::Concern

    def filter_params
      return {} unless params.key?(:filter)
      searchables = (entity.searchable_elements - entity.rangeable_fields).map(&:name).map(&:to_sym)
      rangeables = entity.rangeable_fields.map { |field| { field.name.to_sym => %i[gte lte] } }
      keys = (searchables + rangeables) << :with_deleted
      filter_params_hash = params.require(:filter).permit(keys).to_h
      filter_params_hash.deep_symbolize_keys.transform_values do |value|
        value.try(:regexize) || value
      end
    end
  end
end
