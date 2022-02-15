# frozen_string_literal: true

module Schematics
  module Attributes
    class Email < Citext
      def validators
        super.merge(email: { allow_blank: !required? })
      end

      def default
        return "#{SecureRandom.base58}@#{SecureRandom.base58}.com" if unique? || required?

        super
      end

      def icon
        :envelope
      end
    end
  end
end
