# frozen_string_literal: true

module Schematics
  module Searchkickable
    module Sortable
      extend ActiveSupport::Concern

      def parse_sort_params(params)
        return { implicit_order_column.to_sym => { order: :desc, unmapped_type: 'long' } } unless params # rubocop:disable Layout/LineLength

        ordering = {}
        sort_order = { '+': :asc, '-': :desc }
        params
          .split(',')
          .each do |param|
            sort_sign = param.match?(/\A[+-]/) ? param.slice!(0) : '+'
            ordering[param] = { order: sort_order[sort_sign.to_sym] }
          end
        ordering
      end
    end
  end
end
