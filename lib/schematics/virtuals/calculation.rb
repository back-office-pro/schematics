# frozen_string_literal: true

module Schematics
  module Virtuals
    class Calculation < Virtual
      include Behaviours::Rangeable
      include Behaviours::Numerable

      def available_options = [
        Options::Unit,
        Options::Precision
      ]

      def icon = :square_root_alt

      def open_api_type = ::Float

      def to_sql = super.join
    end
  end
end
