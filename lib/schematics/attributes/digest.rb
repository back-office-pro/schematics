# Copyright © 2025 Dev & Software. All rights reserved.

# THIS SOFTWARE IS PROPRIETARY AND CONFIDENTIAL. UNAUTHORIZED COPYING, DISTRIBUTION, MODIFICATION,
# REVERSE ENGINEERING, OR DISCLOSURE IS STRICTLY PROHIBITED.
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT
# NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE, AND
# NONINFRINGEMENT.
# IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES, OR OTHER
# LIABILITY ARISING FROM, OUT OF, OR IN CONNECTION WITH THE SOFTWARE OR ITS USE.

# frozen_string_literal: true

module Schematics
  module Attributes
    class Digest < Attribute
      include Behaviours::Migratable
      include Behaviours::Fillable

      DEFAULT = '&z%4^~+FS0TQxL8'
      REGEX = /
        (?=.*\d)           # contain at least one number
        (?=.*[a-z])        # contain at least one lowercase letter
        (?=.*[A-Z])        # contain at least one uppercase letter
        (?=.*[[:^alnum:]]) # contain at least one symbol
      /x
      delegate :confirm?, to: :options

      def available_options = super.push(
        Options::Confirm,
        Options::Min
      )

      def database_type = 'string'

      def column_name = "#{super}_digest"

      def default = DEFAULT

      def icon = :key

      def open_api_schema_type = 'password'

      def permitted_params = [name.to_sym, :"#{name}_confirmation"]

      def to_str = super + <<~RUBY
        has_secure_password :#{name}, validations: false
      RUBY

      def validators = super.merge(
        allow_blank:,
        not_pwned: { on_error: :valid },
        confirmation: ({ allow_blank: } if confirm?),
        format: { with: REGEX, message: :password },
        length: {
          minimum: options.min,
          maximum: ::ActiveModel::SecurePassword::MAX_PASSWORD_LENGTH_ALLOWED
        }
      )
    end
  end
end
