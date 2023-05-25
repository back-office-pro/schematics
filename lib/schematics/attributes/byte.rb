# frozen_string_literal: true

module Schematics
  module Attributes
    class Byte < Float
      def format(value)
        value && number_to_human_size(value, **{ precision:, separator: }.compact)
      end

      def icon = :weight_hanging
    end
  end
end
