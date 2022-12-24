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

      def numberable_variables? = variables
        .map(&entity.method(:find_field_by_name))
        .compact
        .reject_is_a?(Behaviours::Numerable)
        .map(&:name)
        .each { |name| errors.add(:function, :numerable, name:) }
    end
  end
end
