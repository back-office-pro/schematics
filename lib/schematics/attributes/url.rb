require 'schematics/attributes/string'

module Schematics
  module Attributes
    class Url < String
      def validators
        super.merge({ url: true })
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
