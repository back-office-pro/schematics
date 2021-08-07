# frozen_string_literal: true

module Schematics
  module Virtuals
    class Comparison < Virtual
      def to_sql
        super.join
      end

      def format(value)
        case value
        when StandardError
          super
        else
          I18n.t(value, default: value.to_s).upcase
        end
      end

      def icon
        :toggle_on
      end
    end
  end
end
