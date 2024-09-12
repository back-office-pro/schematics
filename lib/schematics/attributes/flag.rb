# frozen_string_literal: true

module Schematics
  module Attributes
    class Flag < Enum
      def default = [super]

      def open_api_type = [super]

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
    end
  end
end
