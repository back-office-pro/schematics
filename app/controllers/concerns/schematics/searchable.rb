module Schematics
  module Searchable
    extend ActiveSupport::Concern

    def search_params
      {
        includes: entity.includes,
        where: filter_params.except(:with_deleted),
        order: sorting_params,
        scope_results: (-> (r) { r.with_deleted } if filter_params.key?(:with_deleted)),
      }
    end
  end
end
