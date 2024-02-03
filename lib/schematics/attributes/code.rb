# frozen_string_literal: true

module Schematics
  module Attributes
    class Code < Text
      def available_options = super.push(Options::Language)

      def icon = :code
    end
  end
end
