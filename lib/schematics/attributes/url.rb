# frozen_string_literal: true

module Schematics
  module Attributes
    class Url < Citext
      def available_options = super.excluding(
        Options::Translated,
        Options::Normalization
      )

      def default = ::URI::HTTPS
        .build(host: "www.#{SecureRandom.base58}.com")
        .to_s

      def icon = :wifi

      def normalization = :downcase

      def validators = super.merge(
        url: { allow_blank: }
      )
    end
  end
end
