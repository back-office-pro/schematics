# frozen_string_literal: true

module Schematics
  module Ransackable
    module Sortable
      extend ActiveSupport::Concern

      def parse_sort_params(params)
        params
          &.split(',')
          &.map { |param| param.start_with?('-') ? "#{param[1..]} desc" : "#{param} asc" } ||
          "#{implicit_order_column} desc"
      end
    end
  end
end
