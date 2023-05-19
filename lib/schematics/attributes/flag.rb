# frozen_string_literal: true

module Schematics
  module Attributes
    class Flag < Enum
      def default = [super]

      def open_api_type = [super]

      def permitted_params = { super => [] }

      def format(values)
        Array(values)
          .map(&:to_s)
          .map { super(_1) }
          .join(', ')
      end

      def to_str
        <<~RUBY
          enummer #{name}: #{values.map(&:to_sym)}, _prefix: true
        RUBY
      end
    end
  end
end
