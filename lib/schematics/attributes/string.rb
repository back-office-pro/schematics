# frozen_string_literal: true

require 'schematics/attributes/text'
require 'schematics/behaviours/listable'
require 'active_support/core_ext/securerandom'

module Schematics
  module Attributes
    class String < Text
      include Behaviours::Listable

      def type
        'string'
      end

      def validators
        super.merge(
          {
            length: {
              minimum: options.min,
              maximum: options.limit
            }.compact
          }.compact_blank
        )
      end

      def default
        return SecureRandom.base58 if unique?

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
