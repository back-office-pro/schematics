require 'schematics/attributes/string'

module Schematics
  module Attributes
    class Email < String
      def validators
        super.merge(email: true)
      end

      def default
        return "#{SecureRandom.base58}@#{SecureRandom.base58}.com" if unique? || required?
        super
      end

      def icon
        :envelope
      end
    end
  end
end
