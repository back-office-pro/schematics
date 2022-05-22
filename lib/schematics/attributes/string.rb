# frozen_string_literal: true

module Schematics
  module Attributes
    class String < Text
      include Behaviours::Listable

      def available_options = super.push(
        :unique,
        :encrypted,
        :min,
        :limit,
        :length
      )

      def database_type = 'string'

      def icon = :align_justify

      def validators = super.merge(
        length: {
          minimum: options.min,
          maximum: options.limit,
          is: options.length
        }
      )

      protected

      def migration_options = super.push(
        :limit
      )
    end
  end
end
