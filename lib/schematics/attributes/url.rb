# frozen_string_literal: true

module Schematics
  module Attributes
    class Url < String
      def validators
        super.merge(url: true)
      end

      def default
        return "www.#{SecureRandom.base58}.com" if required?

        super
      end

      def icon
        :chrome
      end
    end
  end
end
