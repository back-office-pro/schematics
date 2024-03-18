# frozen_string_literal: true

module Schematics
  module Attributes
    class Email < Citext
      include Behaviours::Untranslatable
      include Behaviours::Unnormalizable

      def default = "#{SecureRandom.base58}@#{SecureRandom.base58}.com"

      def icon = :envelope

      def normalization = :downcase

      def validators = super.merge(
        email: {
          allow_blank:,
          ban_disposable_email: true,
          partial: true,
          mx_with_fallback: true
        }
      )
    end
  end
end
