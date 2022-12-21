# frozen_string_literal: true

module Schematics
  module Virtuals
    class Calculation < Virtual
      include Behaviours::Rangeable
      include Behaviours::Numerable

      validate :numberable_variables?

      def available_options = [
        Options::Unit,
        Options::Precision
      ]

      def icon = :square_root_alt

      def open_api_type = ::Float

      def to_sql = super.join

      private

      def variables_fields
        variables.map(&entity.method(:find_field_by_name))
      end

      def numberable_variables?
        errors.add(:function, :numerable) unless variables_fields.all?(Behaviours::Numerable)
      end
    end
  end
end
