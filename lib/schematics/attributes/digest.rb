# frozen_string_literal: true

require 'schematics/attributes/attribute'
require 'schematics/behaviours/fillable'

module Schematics
  module Attributes
    class Digest < Attribute
      include Behaviours::Fillable

      def permitted_params
        [super, :"#{super}_confirmation"]
      end

      def validators
        super.merge(
          {
            allow_nil: true,
            length: {
              minimum: options.min,
              maximum: options.limit,
              is: options.length
            }.compact
          }.compact_blank
        )
      end

      def to_str
        <<~RUBY
          has_secure_password :#{@name}
        RUBY
      end

      def default
        @default ||= SecureRandom.base58
      end

      def icon
        :key
      end
    end
  end
end
