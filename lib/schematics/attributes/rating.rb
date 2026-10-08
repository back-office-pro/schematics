# frozen_string_literal: true

module Schematics
  module Attributes
    class Rating < Float
      include Behaviours::Unincrementable

      def available_options = super.excluding(Options::Unit)

      def openai_description = 'An attribute which represents a rating'

      def icon = :star

      def validators = super.merge(
        numericality: { in: 0..5 }
      )
    end
  end
end
