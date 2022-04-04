# frozen_string_literal: true

module Schematics
  module Behaviours
    module Enumerable
      delegate :values, to: :options

      def validators
        super.merge({ inclusion: { in: values }, allow_blank: }.compact_blank)
      end

      def input_collection
        values
          .map { [_1, format(_1)] }
          .tap { _1.unshift ['', ''] unless required? }
          .sort_by(&input_collection_sort_by_key)
          .to_a
      end

      def input_collection_sort_by_key
        :last
      end

      def default
        values.first
      end
    end
  end
end
