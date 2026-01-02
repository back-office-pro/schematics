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
    class Text < Attribute
      include Behaviours::Migratable
      include Behaviours::Renderable
      include Behaviours::Multisearchable
      include Behaviours::Searchable
      include Behaviours::Fillable
      include Behaviours::Preloadable
      include Behaviours::Translatable
      include Behaviours::Normalizable

      delegate :length, :limit, :min, to: :options

      def available_options = super.push(
        Options::Min,
        Options::Limit,
        Options::Length
      )

      def default = SecureRandom.base58(length || limit || min)

      def database_type = 'text'

      def icon = :font

      def format(value)
        value&.to_s
      end

      def validators = super.merge(
        length: {
          minimum: min,
          maximum: limit,
          is: length
        }
      )
    end
  end
end
