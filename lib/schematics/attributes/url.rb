# frozen_string_literal: true

module Schematics
  module Attributes
    class Url < Citext
      def validators
        super.merge(url: { allow_blank: !required? })
      end

      def default
        return "www.#{SecureRandom.base58}.com" if unique? || required?

        super
      end

      def icon
        :chrome
      end
    end
  end
end
