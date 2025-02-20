# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

module Schematics
  module Attributes
    class Rating < Float
      include Behaviours::Unincrementable

      def available_options = super.excluding(Options::Unit)

      def icon = :star

      def validators = super.merge(
        numericality: { in: 0..5 }
      )
    end
  end
end
