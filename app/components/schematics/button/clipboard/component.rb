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
    module Clipboard
      class Component < ApplicationComponent
        option :value

        def css_classes = %w[btn btn-primary btn-sm btn-icon-split]

        def data = {
          controller: 'clipboard',
          action: 'click->clipboard#copy',
          'clipboard-text-value': value,
          'bs-placement': 'right',
          'bs-trigger': 'manual',
          'bs-title': fa_icon(:check, class: 'me-2 text-success') + t('.tooltip'),
          'bs-html': true
        }

        def icon = :clipboard
      end
    end
  end
end
