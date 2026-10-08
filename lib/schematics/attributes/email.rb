# frozen_string_literal: true

module Schematics
  module Attributes
    # :reek:SubclassedFromCoreClass
    class Email < String
      include Behaviours::Untranslatable
      include Behaviours::Unnormalizable

      def available_options = super.excluding(Options::CaseInsensitive)

      def case_insensitive? = true

      def default = "#{SecureRandom.base58}@#{SecureRandom.base58}.com"

      def openai_description = 'An attribute which represents an email address'

      def icon = :envelope

      def normalization = :downcase

      def validators = super.merge(
        email: {
          allow_blank:,
          ban_disposable_email: true,
          partial: true
        }
      )
    end
  end
end
