# frozen_string_literal: true

module Schematics
  module Searchable
    extend ActiveSupport::Concern

    def search_params
      {
        includes: entity.includes,
        where: filter_params.except(:with_deleted),
        order: sorting_params,
        scope_results: lambda { |results|
          results
            .then_tap { _1.with_deleted if filter_params.key?(:with_deleted) }
            .accessible_by(current_ability)
        }
      }
    end

    def log_search!
      return unless params.key?(:filter)

      current_user
        .searches
        .create!(model: model_class, filters: filter_params_to_h)
    end
  end
end
