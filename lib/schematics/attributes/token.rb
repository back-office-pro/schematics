# Copyright © 2025 Dev & Software. All rights reserved.

# THIS SOFTWARE IS PROPRIETARY AND CONFIDENTIAL. UNAUTHORIZED COPYING, DISTRIBUTION, MODIFICATION,
# REVERSE ENGINEERING, OR DISCLOSURE IS STRICTLY PROHIBITED.
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT
# NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE, AND
# NONINFRINGEMENT.
# IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES, OR OTHER
# LIABILITY ARISING FROM, OUT OF, OR IN CONNECTION WITH THE SOFTWARE OR ITS USE.

# frozen_string_literal: true

require 'active_support/core_ext/securerandom'

module Schematics
  module Attributes
    class Token < Attribute
      include Behaviours::Migratable
      include Behaviours::Renderable
      include Behaviours::Encryptable

      LENGTH = 32

      def available_options = super.excluding(Options::Encrypted)

      def database_type = 'string'

      def encrypted? = true

      def unique? = true

      def default = SecureRandom.base58(LENGTH)

      def openai_description = 'An attribute which represents a token'

      def icon = :passport

      def to_str = super + <<~RUBY
        has_secure_token :#{name}, length: #{LENGTH}
      RUBY
    end
  end
end
