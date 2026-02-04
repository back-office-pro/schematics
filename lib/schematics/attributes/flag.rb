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
    class Flag < Enum
      def default = [super]

      def open_api_schema_type = [super]

      def open_api_query_type = super.first

      def permitted_params = { super => [] }

      def input_name = "#{super}[]"

      def format(values)
        Array(values)
          .map(&:to_s)
          .map { super(_1) }
          .join(', ')
      end

      def openai_description = 'An attribute which represents an enumeration with multiple choices'

      def to_str
        <<~RUBY
          enummer #{name}: #{to_h}, _prefix: true
        RUBY
      end

      def validators
        super.merge inclusion: { in: values.map(&:to_sym) }
      end
    end
  end
end
