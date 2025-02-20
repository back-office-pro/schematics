# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

module Schematics
  module Attributes
    class Byte < Float
      include Behaviours::Unincrementable

      def available_options = super.excluding(Options::Unit)

      def format(value)
        value && number_to_human_size(value, **{ precision:, separator: }.compact)
      end

      def icon = :weight_hanging
    end
  end
end
