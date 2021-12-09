# frozen_string_literal: true

require 'action_dispatch/http/mime_type'

module Schematics
  module Attributes
    class Mime < String
      def format(value)
        ::Mime::Type
          .lookup(value)
          .symbol
          .to_s
          .upcase
      end

      def icon
        :file
      end
    end
  end
end
