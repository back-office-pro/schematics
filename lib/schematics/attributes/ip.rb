# frozen_string_literal: true

require 'resolv'

module Schematics
  module Attributes
    # :reek:SubclassedFromCoreClass
    class Ip < String
      def encrypted? = true

      def default = '::1'

      def icon = :network_wired

      def validators
        super.merge(allow_blank:, format: { with: ::Resolv::AddressRegex, message: :ip_address })
      end
    end
  end
end
