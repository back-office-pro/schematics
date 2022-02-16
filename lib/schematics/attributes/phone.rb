# frozen_string_literal: true

module Schematics
  module Attributes
    class Phone < String
      def validators
        super.merge(phone: { allow_blank: })
      end

      def default
        Array.new(10) { rand(10) }.join
      end

      def format(value)
        value && number_to_phone(value)
      end

      def icon
        :phone
      end
    end
  end
end
