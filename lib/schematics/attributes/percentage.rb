# frozen_string_literal: true

module Schematics
  module Attributes
    class Percentage < Float
      include Behaviours::Unincrementable

      def available_options = super.excluding(Options::Unit)

      def format(value)
        value && number_to_percentage(value, **{ precision:, separator:, delimiter: }.compact)
      end

      def openai_description = 'An attribute which represents a percentage'

      def icon = :percent

      def unit = '%'
    end
  end
end
