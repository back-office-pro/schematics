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
  module LicenseComparisonModal
    module ListItem
      class Component < ApplicationComponent
        option :model_class, optional: true
        option :icon, optional: true
        option :text, optional: true
        option :count, default: -> { '∞' }

        def icon
          super || model_class.entity.icon
        end

        def text
          super || model_class
            .human_name(count:)
            .then_tap { it.capitalize if zero? }
        end

        def css_class
          'text-decoration-line-through' if zero?
        end

        def zero?
          count == 0 # rubocop:disable Style/NumericPredicate
        end
      end
    end
  end
end
