# frozen_string_literal: true

module Schematics
  module Virtuals
    class Malformed < Virtual
      def to_sql
        super.join
      end

      def function
        <<~RUBY.squish
          raise ArgumentError
        RUBY
      end

      def icon
        :exclamation_triangle
      end
    end
  end
end
