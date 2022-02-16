# frozen_string_literal: true

module Schematics
  module Attributes
    class Email < Citext
      def validators
        super.merge(email: { allow_blank: })
      end

      def default
        "#{SecureRandom.base58}@#{SecureRandom.base58}.com"
      end

      def icon
        :envelope
      end
    end
  end
end
