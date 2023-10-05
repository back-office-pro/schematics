# frozen_string_literal: true

module Schematics
  module Attributes
    class Rating < Float
      def available_options = super.excluding(Options::AutoIncrement)

      def icon = :star

      def validators = super.merge(
        numericality: { in: 0..5 }
      )
    end
  end
end
