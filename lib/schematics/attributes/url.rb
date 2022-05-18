# frozen_string_literal: true

module Schematics
  module Attributes
    class Url < Citext
      def default = "https://www.#{SecureRandom.base58}.com"

      def encrypted? = true

      def icon = :chrome

      def validators = super.merge(
        url: { allow_blank: }
      )
    end
  end
end
