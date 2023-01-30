# frozen_string_literal: true

module Schematics
  module Searchkickable
    module Sortable
      extend ActiveSupport::Concern

      # :reek:ControlParameter
      def parse_sort_params(params)
        params
          &.split(',')
          &.map { { _1 => { order: sort_order[_1.match?(/\A[+-]/) ? _1.slice!(0) : '+'] } } }
          &.reduce(:merge) ||
          { implicit_order_column.to_sym => { order: :desc, unmapped_type: 'long' } }
      end

      private

      def sort_order = { '+' => :asc, '-' => :desc } # rubocop:disable Style/StringHashKeys
    end
  end
end
