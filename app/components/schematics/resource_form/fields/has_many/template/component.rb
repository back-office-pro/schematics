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
  module ResourceForm
    module Fields
      module HasMany
        module Template
          class Component < ApplicationComponent
            delegate :entity, :belongs_to, :name, to: :field, private: true
            delegate :model_class, :fillable_elements, :icon, to: :entity, private: true
            delegate :human_name, to: :model_class

            option :form
            option :field

            def id = "nested-association-#{name}"

            alias css_class id

            def elements = fillable_elements
              .excluding(belongs_to)
              .stable_sort_by(&:weight)
          end
        end
      end
    end
  end
end
