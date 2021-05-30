# frozen_string_literal: true

module Schematics
  module Behaviours
    module Enumerable
      def values
        options[:values]
      end

      def validators
        super.merge(inclusion: { in: values }, allow_nil: !required?)
      end

      def input_type
        :select
      end

      def input_collection
        values.collect { |value| [value, format(value)] }
      end

      def default
        super || values.first
      end
    end
  end
end
