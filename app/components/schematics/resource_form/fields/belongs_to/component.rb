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
  module ResourceForm
    module Fields
      module BelongsTo
        class Component < Fields::Component
          delegate :column_name, :model_class, :descriptor, to: :field
          delegate :gender, to: :model_class, private: true

          memoize def collection = model_class
            .preload_all
            .order(created_at: :desc)
            .limit(Loadable::ASSOCIATIONS_LIMIT)
            .to_a
            .union(Array(value))
            .compact
            .map { [_1.to_s, _1.id] }
            .sort

          def prompt = t('prompt', gender:, attribute_name: attribute_name.downcase)

          def data = {
            controller: 'dropdowns--association-dropdown',
            'dropdowns--association-dropdown-field-value': descriptor.name,
            'dropdowns--association-dropdown-url-value': url
          }

          alias label attribute_name

          protected

          def url = resources_path(model_class, format: :json)
        end
      end
    end
  end
end
