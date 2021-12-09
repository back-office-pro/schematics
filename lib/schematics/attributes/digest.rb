# frozen_string_literal: true

module Schematics
  module Attributes
    class Digest < Attribute
      include Behaviours::Fillable
      REGEX = /
        (?=.*\d)           # contain at least one number
        (?=.*[a-z])        # contain at least one lowercase letter
        (?=.*[A-Z])        # contain at least one uppercase letter
        (?=.*[[:^alnum:]]) # contain at least one symbol
      /x

      def permitted_params
        [super, :"#{super}_confirmation"]
      end

      def validators
        super.merge(
          {
            allow_blank: true,
            format: { with: REGEX, message: :password },
            length: {
              minimum: options.min,
              maximum: options.limit
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
        'Azerty1!'
      end

      def icon
        :key
      end
    end
  end
end
