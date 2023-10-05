# frozen_string_literal: true

module Schematics
  module Attributes
    class Url < Citext
      include Behaviours::Untranslatable
      include Behaviours::Unnormalizable

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
