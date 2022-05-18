# frozen_string_literal: true

module Schematics
  module Virtuals
    class Malformed < Virtual
      def function = <<~RUBY.squish
        raise ArgumentError
      RUBY

      def icon = :triangle_exclamation

      def to_sql = super.join
    end
  end
end
