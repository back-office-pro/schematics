# frozen_string_literal: true

module Schematics
  module Behaviours
    module Enumerable
      def values
        options[:values]
      end

      def validators
        super.merge(inclusion: { in: values }, allow_blank: !required?)
      end

      def input_type
        :select
      end

      def input_collection
        values
          .collect { |value| [value, format(value)] }
          .tap { _1.unshift ['', ''] unless required? }
      end

      def default
        super || values.first
      end
    end
  end
end
