# frozen_string_literal: true

module Schematics
  module Virtuals
    class Calculation < Virtual
      include Behaviours::Rangeable
      include Behaviours::Numerable

      def available_options = [
        Options::Unit,
        Options::Precision,
        Options::Separator
      ]

      def icon = :square_root_alt

      def open_api_type = ::Float

      def to_sql = "(#{super.join})"

      private

      def allowed_variables = entity
        .numerable_fields
        .map(&:name)
    end
  end
end
