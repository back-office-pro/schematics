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
  module Button
    module Edit
      class Component < ApplicationComponent
        delegate :class, to: :resource, prefix: :model, private: true
        delegate :entity, to: :model_class, private: true
        option :resource
        option :compact, default: -> { true }

        def compact? = compact

        def css_classes = class_names(
          'btn',
          'btn-primary',
          'btn-sm',
          'btn-icon-split': !compact?,
          'ms-1': !compact?
        )

        def data = {
          turbo_frame: '_top',
          controller: 'tooltip',
          'bs-custom-class': ('responsive-button-tooltip-xxl' unless compact?)
        }.compact

        def title = t('.text')

        def render?
          can?(:edit, resource)
        end
      end
    end
  end
end
