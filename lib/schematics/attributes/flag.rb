# frozen_string_literal: true

module Schematics
  module Attributes
    class Flag < Enum
      def default = [super]

      def open_api_schema_type = [super]

      def open_api_query_type = super.first

      def permitted_params = { super => [] }

      def input_name(*) = "#{super}[]"

      def format(values)
        Array(values)
          .map(&:to_s)
          .map { super(it) }
          .join(', ')
      end

      def openai_description = 'An attribute which represents an enumeration with multiple choices'

      def to_str
        <<~RUBY
          enummer #{name}: #{to_h}, _prefix: true
        RUBY
      end

      def validators
        super.merge inclusion: { in: values.map(&:to_sym) }
      end
    end
  end
end
