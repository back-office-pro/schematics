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
    module Attribute
      class Component < ApplicationComponent
        delegate :class, to: 'builder.object', prefix: :attribute
        delegate :allowed_association_types, :icon, to: 'builder.object'
        delegate :compatible_types, to: :attribute_class, private: true
        option :builder

        def collection = compatible_types
          .map { [_1.model_name.human, _1.type] }
          .sort

        def prompt = t('prompt', attribute_name:)

        def title = attribute_class
          .model_name
          .human

        private

        def attribute_name = Attributes::Attribute
          .human_attribute_name('name')
          .downcase
      end
    end
  end
end
