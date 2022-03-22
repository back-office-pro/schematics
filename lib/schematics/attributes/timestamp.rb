# frozen_string_literal: true

module Schematics
  module Attributes
    class Timestamp < Attribute
      def open_api_type
        ::DateTime
      end

      def type
        'datetime' # Rails converts timestamp to datetime in database
      end
    end
  end
end
