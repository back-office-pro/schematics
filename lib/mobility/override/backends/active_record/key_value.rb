# Copyright © 2025 Dev & Software. All rights reserved.

# THIS SOFTWARE IS PROPRIETARY AND CONFIDENTIAL. UNAUTHORIZED COPYING, DISTRIBUTION, MODIFICATION,
# REVERSE ENGINEERING, OR DISCLOSURE IS STRICTLY PROHIBITED.
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT
# NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE, AND
# NONINFRINGEMENT.
# IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES, OR OTHER
# LIABILITY ARISING FROM, OUT OF, OR IN CONNECTION WITH THE SOFTWARE OR ITS USE.

# frozen_string_literal: true

module Mobility
  module Override
    module Backends
      module ActiveRecord
        module KeyValue
          def define_has_many_association(klass, attributes)
            attrs_method_name = :"__#{association_name}_attributes"
            association_attributes = (klass.instance_variable_get(:"@#{attrs_method_name}") || []) + attributes # rubocop:disable Layout/LineLength
            klass.instance_variable_set(:"@#{attrs_method_name}", association_attributes)
            context = self
            klass.has_many association_name,
                           -> { where(context.key_column => association_attributes) },
                           as: belongs_to,
                           class_name: class_name.name,
                           inverse_of: belongs_to,
                           autosave: true,
                           dependent: :destroy
          end
        end
      end
    end
  end
end
