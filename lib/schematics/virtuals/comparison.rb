# frozen_string_literal: true

module Schematics
  module Virtuals
    class Comparison < Virtual
      def open_api_type
        :boolean
      end

      def to_sql
        super.join
      end

      def format(value)
        case value
        when StandardError
          super
        else
          translate(value, default: value.to_s).upcase
        end
      end

      def icon
        :toggle_on
      end
    end
  end
end
