# frozen_string_literal: true

require 'schematics/virtuals/virtual'
require 'schematics/behaviours/rangeable'

module Schematics
  module Virtuals
    class Calculation < Virtual
      include Behaviours::Rangeable

      def to_sql
        super.join
      end

      def unit
        @options[:unit]
      end

      def scale
        @options[:scale]
      end

      def format(value)
        return value.to_s if value.is_a?(::StandardError)

        [value.round(scale.to_i), unit].compact.join(' ')
      end

      def icon
        :square_root_alt
      end
    end
  end
end
