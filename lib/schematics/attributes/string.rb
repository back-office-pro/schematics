# frozen_string_literal: true

module Schematics
  module Attributes
    class String < Text
      include Behaviours::Listable
      delegate :limit, to: :options

      def available_options = super.push(
        :unique,
        :encrypted,
        :min,
        :limit,
        :length
      )

      def database_type = 'string'

      def default = SecureRandom.base58(limit || 10)

      def icon = :align_justify

      def validators = super.merge(
        length: {
          minimum: options.min,
          maximum: options.limit,
          is: options.length
        }
      )
    end
  end
end
