# frozen_string_literal: true

module Schematics
  module Attributes
    class Url < Citext
      def encrypted? = true
      def default = "https://www.#{SecureRandom.base58}.com"
      def icon = :chrome

      def validators
        super.merge(url: { allow_blank: })
      end
    end
  end
end
