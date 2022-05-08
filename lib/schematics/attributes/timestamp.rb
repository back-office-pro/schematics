# frozen_string_literal: true

module Schematics
  module Attributes
    class Timestamp < Attribute
      def open_api_type = ::DateTime
      def database_type = 'datetime'
    end
  end
end
