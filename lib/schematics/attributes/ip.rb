# Copyright © 2025 Dev & Software. All rights reserved.
#
# THIS SOFTWARE IS PROPRIETARY AND CONFIDENTIAL. UNAUTHORIZED COPYING, DISTRIBUTION, MODIFICATION,
# REVERSE ENGINEERING, OR DISCLOSURE IS STRICTLY PROHIBITED.
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT
# NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE, AND
# NONINFRINGEMENT.
# IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES, OR OTHER
# LIABILITY ARISING FROM, OUT OF, OR IN CONNECTION WITH THE SOFTWARE OR ITS USE.

# frozen_string_literal: true

require 'ipaddr'
require 'resolv'

module Schematics
  module Attributes
    # :reek:SubclassedFromCoreClass
    class Ip < String
      include Behaviours::Untranslatable
      include Behaviours::Unnormalizable

      def default = '::1'

      def icon = :network_wired

      def format(value)
        return unless value

        address = ::IPAddr.new(value)
        address.mask(address.ipv4? ? 24 : 48).to_s
      end

      def validators = super.merge(
        allow_blank:,
        format: { with: ::Resolv::AddressRegex, message: :ip_address }
      )
    end
  end
end
