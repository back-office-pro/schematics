# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

module Schematics
  module Filterable
    extend ActiveSupport::Concern

    def log_search!
      current_user.log_search!(model_class.to_s, filter_params)
    end

    def filter_params
      return {} unless params.key?(filter_key)

      params
        .expect(filter_key => permitted_filters)
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
