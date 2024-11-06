# frozen_string_literal: true

module Schematics
  module Ransackable
    module Sortable
      extend ActiveSupport::Concern

      # :reek:ControlParameter
      def parse_sort_params(params)
        params&.map { _1.start_with?('-') ? "#{_1[1..]} desc" : "#{_1} asc" } ||
          "#{implicit_order_column} desc"
      end
    end
  end
end
