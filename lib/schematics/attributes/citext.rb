# frozen_string_literal: true

module Schematics
  module Attributes
    class Citext < Text
      include Behaviours::Listable

      def type
        'citext'
      end

      def case_sensitive?
        false
      end

      def icon
        :align_justify
      end
    end
  end
end
