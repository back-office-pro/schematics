# frozen_string_literal: true

module Schematics
  module Attributes
    class Citext < Text
      include Behaviours::Listable

      def database_type = 'citext'
      def case_sensitive? = false
      def icon = :align_justify
    end
  end
end
