# frozen_string_literal: true

module Schematics
  module Attributes
    class Email < Citext
      def available_options = super.excluding(
        Options::Translated,
        Options::Normalization
      )

      def default = "#{SecureRandom.base58}@#{SecureRandom.base58}.com"

      def icon = :envelope

      def normalization = :downcase

      def validators = super.merge(
        email: { allow_blank: }
      )
    end
  end
end
