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
        case value
        when StandardError
          super
        else
          [value.round(scale.to_i), unit].compact.join(' ')
        end
      end

      def icon
        :square_root_alt
      end
    end
  end
end
