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

module Schematics
  module Behaviours
    module Fillable
      delegate :group, :readonly?, to: :options

      def available_options = super.push(
        Options::Group,
        Options::Default,
        Options::Readonly
      )

      def json_default = default

      def permitted_json_params = permitted_params

      def permitted_params = column_name.to_sym

      def input_name = "#{entity.table_name}[#{column_name}]"

      def open_api_body_type = open_api_schema_type

      def to_open_api_body = [:"#{column_name}#{'!' if required?}", open_api_body_type]

      def to_str
        return super unless options.default

        super + <<~RUBY
          attribute :#{name}, default: -> { #{options.default.to_json} }
        RUBY
      end
    end
  end
end
