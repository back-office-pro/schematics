# frozen_string_literal: true

require 'action_dispatch/http/mime_type'

module Schematics
  module Attributes
    # :reek:SubclassedFromCoreClass
    class Mime < String
      def format(value)
        value && ::Mime::Type.lookup(value).symbol.to_s.upcase
      end

      def validators
        super.merge(allow_blank:, format: { with: ::Mime::Type::MIME_REGEXP, message: :mime_type })
      end

      def default
        'image/png'
      end

      def icon
        :file
      end
    end
  end
end
