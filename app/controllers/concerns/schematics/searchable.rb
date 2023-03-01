# frozen_string_literal: true

module Schematics
  module Searchable
    extend ActiveSupport::Concern

    def log_search!
      return if filter_params.empty?

      current_user
        .searches
        .create!(model: model_class, filters: filter_params)
    end

    def filter_params
      return {} unless params.key?(filter_key)

      params
        .require(filter_key)
        .permit(permitted_filters)
        .to_h
        .compact_blank
        .deep_symbolize_keys
    end

    private

    def filter_key = Ransack.options[:search_key]

    def permitted_filters = entity
      .searchable_elements
      .grep_v(Schematics::Behaviours::Rangeable)
      .map(&:name)
      .map(&:to_sym)
      .push(:with_deleted)
      .concat(entity.rangeable_elements.map { { _1.name.to_sym => %i[gte lte] } })
  end
end
