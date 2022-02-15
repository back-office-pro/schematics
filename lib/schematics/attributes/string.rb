# frozen_string_literal: true

require 'active_support/core_ext/securerandom'

module Schematics
  module Attributes
    class String < Text
      include Behaviours::Listable

      def type
        'citext'
      end

      def case_sensitive?
        false
      end

      def validators
        super.merge(
          {
            length: {
              minimum: options.min,
              maximum: options.limit,
              is: options.length
            }.compact
          }.compact_blank
        )
      end

      def default
        return SecureRandom.base58 if unique?
        return 'MyString' if required?

        super
      end

      def input_type
        :input
      end

      def format(value)
        value&.to_s
      end
    end
  end
end
