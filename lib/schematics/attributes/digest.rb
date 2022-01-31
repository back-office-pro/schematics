# frozen_string_literal: true

module Schematics
  module Attributes
    class Digest < Attribute
      include Behaviours::Fillable

      delegate :confirm?, to: :options

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
            allow_blank: !required?,
            confirmation: ({ allow_blank: !required? } if confirm?),
            format: { with: REGEX, message: :password },
            length: {
              minimum: options.min,
              maximum: ActiveModel::SecurePassword::MAX_PASSWORD_LENGTH_ALLOWED
            }.compact
          }.compact_blank
        )
      end

      def to_str
        <<~RUBY
          has_secure_password :#{@name}, validations: false
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
