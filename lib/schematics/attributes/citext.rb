# frozen_string_literal: true

module Schematics
  module Attributes
    class Citext < Text
      include Behaviours::Listable

      def case_sensitive? = false

      def database_type = 'citext'

      def icon = :align_justify
    end
  end
end
