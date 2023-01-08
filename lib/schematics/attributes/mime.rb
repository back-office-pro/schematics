# frozen_string_literal: true

require 'action_dispatch/http/mime_type'

module Schematics
  module Attributes
    # :reek:SubclassedFromCoreClass
    class Mime < String
      include Behaviours::Enumerable

      def icon = :file

      def format(value)
        value && ::Mime::Type.lookup(value).symbol.to_s.upcase
      end

      def values = ::Mime::EXTENSION_LOOKUP
        .values
        .map { _1.__send__(:string) }
        .uniq
    end
  end
end
