# frozen_string_literal: true

module Schematics
  module Attributes
    class Url < Citext
      include Behaviours::Untranslatable
      include Behaviours::Unnormalizable
      delegate :schemes, to: :options

      def available_options = super.push(Options::Scheme)

      def default = ::URI
        .const_get(schemes&.first&.upcase || :HTTPS)
        .build(host: "www.#{SecureRandom.base58}.com")
        .to_s

      def icon = :wifi

      def normalization = :downcase

      def validators = super.merge(
        url: { allow_blank:, schemes: }
      )
    end
  end
end
