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

require 'action_dispatch/http/mime_type'

module Schematics
  module Attributes
    # :reek:SubclassedFromCoreClass
    class Mime < String
      include Behaviours::Enumerable
      include Behaviours::Untranslatable
      include Behaviours::Unnormalizable

      def icon = :file

      def format(value)
        value && ::Mime::Type.lookup(value).symbol.to_s.upcase
      end

      def collection = super.sort

      def values = ::Mime::LOOKUP.keys
    end
  end
end
