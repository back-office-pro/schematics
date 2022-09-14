# frozen_string_literal: true

module Schematics
  module Attributes
    class Rating < Float
      def icon = :star

      def validators = super.merge(
        numericality: { in: 0..5 }
      )
    end
  end
end
