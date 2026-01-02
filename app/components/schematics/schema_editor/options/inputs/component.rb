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
    module Options
      module Inputs
        class Component < ApplicationComponent
          delegate :option_name, to: :option

          option :builder
          option :option
          option :object

          class << self
            def build(builder:, option:, object:)
              module_parent
                .const_get(option.input_type.to_s.camelize)::Component
                .new(builder:, option:, object:)
            end
          end

          def include_hidden = false # rubocop:disable Naming/PredicateMethod

          def include_blank(name = attribute_name)
            t('prompt', attribute_name: name.downcase.singularize(I18n.locale))
          end

          protected

          def attribute_name(name = option_name)
            Schematics::Options::Wrapper.human_attribute_name(name)
          end
        end
      end
    end
  end
end
