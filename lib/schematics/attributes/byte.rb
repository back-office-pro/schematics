# frozen_string_literal: true

module Schematics
  module Attributes
    class Byte < Float
      include Behaviours::Unincrementable

      def available_options = super.excluding(Options::Unit)

      def format(value)
        value && number_to_human_size(value, **{ precision:, separator:, delimiter: }.compact)
      end

      def openai_description = 'An attribute which represents a byte'

      def icon = :weight_hanging
    end
  end
end
