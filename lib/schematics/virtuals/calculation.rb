# Copyright © 2025 Dev & Software. All rights reserved.
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

      def open_api_schema_type = 'float'

      def allowed_variables = entity
        .numerable_elements
        .map(&:name)

      protected

      def variable_method = :to_f
    end
  end
end
