# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

require 'resolv'

module Schematics
  module Attributes
    # :reek:SubclassedFromCoreClass
    class Ip < String
      include Behaviours::Untranslatable
      include Behaviours::Unnormalizable

      def default = '::1'

      def icon = :network_wired

      def validators = super.merge(
        allow_blank:,
        format: { with: ::Resolv::AddressRegex, message: :ip_address }
      )
    end
  end
end
