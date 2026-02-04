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
  module Options
    class Option
      delegate :hidden?, :option_name, to: :class

      class << self
        def hidden? = false

        def option_name = name
          .demodulize
          .underscore
          .to_sym

        def openai_type = input_type.to_s

        def openai_enum = {}

        def to_openai_schema = {
          option_name => {
            type: 'object',
            additionalProperties: false,
            required: [option_name.to_s],
            properties: {
              option_name => {
                type: openai_type,
                description: openai_description,
                **openai_enum
              }
            }
          }
        }
      end
    end
  end
end
