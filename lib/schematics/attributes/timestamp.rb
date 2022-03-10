# frozen_string_literal: true

module Schematics
  module Attributes
    class Timestamp < Attribute
      def type
        'datetime' # Rails converts timestamp to datetime in database
      end
    end
  end
end
