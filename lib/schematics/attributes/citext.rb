# frozen_string_literal: true

module Schematics
  module Attributes
    class Citext < String
      def type
        'citext'
      end

      def case_sensitive?
        false
      end
    end
  end
end
