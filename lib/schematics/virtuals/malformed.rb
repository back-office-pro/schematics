# frozen_string_literal: true

module Schematics
  module Virtuals
    class Malformed < Virtual
      def icon = :triangle_exclamation

      def to_sql = super.join

      protected

      def method_body = <<~RUBY.squish
        raise ArgumentError
      RUBY
    end
  end
end
