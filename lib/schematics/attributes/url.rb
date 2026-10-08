# frozen_string_literal: true

module Schematics
  module Attributes
    # :reek:SubclassedFromCoreClass
    class Url < String
      include Behaviours::Untranslatable
      include Behaviours::Unnormalizable

      delegate :schemes, to: :options

      def available_options = super
        .excluding(Options::CaseInsensitive)
        .push(Options::Schemes)

      def case_insensitive? = true

      def default = ::URI
        .const_get(schemes&.first&.upcase || :HTTPS)
        .build(host: "www.#{SecureRandom.base58}.com")
        .to_s

      def openai_description = 'An attribute which represents a URL'

      def icon = :wifi

      def normalization = :downcase

      def validators = super.merge(
        url: { allow_blank:, schemes: }
      )
    end
  end
end
