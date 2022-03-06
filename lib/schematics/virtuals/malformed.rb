# frozen_string_literal: true

module Schematics
  module Virtuals
    class Malformed < Virtual
      def open_api_type
        'string'
      end

      def to_sql
        super.join
      end

      def function
        <<~RUBY.chomp
          raise ArgumentError
        RUBY
      end

      def icon
        :exclamation_triangle
      end
    end
  end
end
