# frozen_string_literal: true

require 'action_dispatch/http/mime_type'

module Schematics
  module Attributes
    # :reek:SubclassedFromCoreClass
    class Mime < String
      def default = 'image/png'

      def icon = :file

      def format(value)
        value && ::Mime::Type.lookup(value).symbol.to_s.upcase
      end

      def validators = super.merge(
        allow_blank:,
        format: { with: ::Mime::Type::MIME_REGEXP, message: :mime_type }
      )
    end
  end
end
