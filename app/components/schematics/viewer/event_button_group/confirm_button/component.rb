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
  module Viewer
    module EventButtonGroup
      module ConfirmButton
        class Component < Button::Component
          def form_css_classes = %w[d-inline btn-check position-relative]

          def text = t(
            event.name,
            default: t('.default'),
            scope: ['.', resource.class.entity.name]
          )

          def target = "confirm-dialog-#{resource.id}-#{event.id}"

          def data = super
            .except(:turbo_method, :action)
            .merge('bs-toggle': 'modal', 'bs-target': "##{target}")
        end
      end
    end
  end
end
