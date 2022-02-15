# frozen_string_literal: true

module Schematics
  module Attributes
    class Phone < String
      def validators
        super.merge(phone: { allow_blank: !required? })
      end

      def default
        return Array.new(10) { rand(10) }.to_s if unique? || required?

        super
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
