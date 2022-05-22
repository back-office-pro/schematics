# frozen_string_literal: true

module Schematics
  module Attributes
    class Citext < String
      def case_sensitive? = false

      def database_type = 'citext'
    end
  end
end
