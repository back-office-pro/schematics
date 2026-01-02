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
  module SchemaEditor
    module Template
      module Attribute
        class Component < Template::Component
          with_collection_parameter :constant

          class << self
            def belongs_to_has_one(form:)
              new(
                form:,
                constant: Attributes::BelongsTo,
                options: { inverse_association_type: 'has_one' },
                slug: 'belongs-to-has-one'
              )
            end
          end

          def initialize(form:, constant:, options: nil, slug: nil)
            super
            @form = form
            @constant = constant
            @options = options
            @slug = slug || @constant.type.dasherize
          end

          def attribute = @constant.new(
            id: 'RANDOM_UUID',
            entity:,
            options: @options
          )
        end
      end
    end
  end
end
