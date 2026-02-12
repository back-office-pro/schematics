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
  module Button
    module Destroy
      class Component < ApplicationComponent
        option :resource
        option :compact, default: -> { true }

        def compact? = compact

        def css_classes = class_names(
          'btn',
          'btn-danger',
          'btn-sm',
          'btn-icon-split': !compact?,
          'ms-1': !compact?
        )

        def url = resource_path(resource)

        def data = {
          turbo_frame: '_top',
          controller: 'tooltip',
          'bs-toggle': 'modal',
          'bs-target': "##{target}",
          'bs-custom-class': ('responsive-button-tooltip-xxl' unless compact?)
        }.compact

        def target = "confirm-dialog-#{resource.id}"

        def title = t('.title')

        def render?
          can?(:destroy, resource)
        end
      end
    end
  end
end
