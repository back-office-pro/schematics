# frozen_string_literal: true

module Schematics
  module Attributes
    class Uuid < Attribute
      def default
        return SecureRandom.uuid if required?

        super
      end
    end
  end
end
