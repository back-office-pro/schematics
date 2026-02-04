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
  module Behaviours
    module Generatable
      def to_openai_schema = {
        type.to_sym => {
          type: 'object',
          additionalProperties: false,
          required: %w[name type options],
          properties: {
            type: {
              type: 'string',
              description: openai_description,
              enum: [type]
            },
            name: { '$ref': '#/$defs/name' },
            options: {
              type: 'object',
              additionalProperties: false,
              anyOf: available_options
                .reject(&:hidden?)
                .map(&:option_name)
                .map { { '$ref': "#/$defs/#{_1}" } }
            }
          }
        }
      }
    end
  end
end
