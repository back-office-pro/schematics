# frozen_string_literal: true

module Schematics
  module Attributes
    class Url < Citext
      def validators
        super.merge(url: { allow_blank: })
      end

      def default
        "https://www.#{SecureRandom.base58}.com"
      end

      def icon
        :chrome
      end
    end
  end
end
