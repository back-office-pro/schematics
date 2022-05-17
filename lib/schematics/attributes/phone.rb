# frozen_string_literal: true

module Schematics
  module Attributes
    # :reek:SubclassedFromCoreClass
    class Phone < String
      def default
        ::Array
          .new(10) { rand(10) }
          .join
      end

      def encrypted? = true

      def format(value)
        value && number_to_phone(value)
      end

      def icon = :phone

      def validators
        super.merge(phone: { allow_blank: })
      end
    end
  end
end
