# frozen_string_literal: true

module Schematics
  module Attributes
    class Flag < Enum
      def default = [super]

      def open_api_schema_type = [super]

      def open_api_query_type = super.first

      def permitted_params = { super => [] }

      def input_name = "#{super}[]"

      def format(values)
        Array(values)
          .map(&:to_s)
          .map { super(_1) }
          .join(', ')
      end

      def to_str
        <<~RUBY
          enummer #{name}: #{to_h}, _prefix: true
        RUBY
      end

      def validators
        super.merge(inclusion: { in: values.map(&:to_sym), allow_blank: }.compact_blank)
      end
    end
  end
end
