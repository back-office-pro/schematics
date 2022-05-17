# frozen_string_literal: true

module Schematics
  module Attributes
    class Citext < Text
      include Behaviours::Listable

      def case_sensitive? = false

      def icon = :align_justify

      def type = 'citext'
    end
  end
end
