# frozen_string_literal: true

module Schematics
  module Attributes
    class Phone < String
      def validators
        super.merge(phone: true)
      end

      def default
        return Array.new(10) { rand(10) }.to_s if required?

        super
      end

      def icon
        :phone
      end
    end
  end
end
