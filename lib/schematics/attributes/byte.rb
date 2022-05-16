# frozen_string_literal: true

module Schematics
  module Attributes
    class Byte < Float
      def icon = :weight_hanging

      def format(value)
        value && number_to_human_size(value, **{ precision: }.compact)
      end
    end
  end
end
