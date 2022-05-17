# frozen_string_literal: true

module Schematics
  module Attributes
    class Email < Citext
      def default = "#{SecureRandom.base58}@#{SecureRandom.base58}.com"

      def encrypted? = true

      def icon = :envelope

      def validators
        super.merge(email: { allow_blank: })
      end
    end
  end
end
