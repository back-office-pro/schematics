# frozen_string_literal: true

module Schematics
  module Searchable
    extend ActiveSupport::Concern

    def search_params
      {
        includes: entity.includes,
        where: filter_params.except(:with_deleted),
        order: sorting_params,
        scope_results: lambda do |results|
          results = results.with_deleted if filter_params.key?(:with_deleted)
          results.accessible_by(current_ability)
        end,
      }
    end
  end
end
