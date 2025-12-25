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
    module GoogleSignIn
      class Component < ApplicationComponent
        delegate :google_sign_in_feature_flag, to: '::Configuration', private: true

        def css_classes = %w[btn btn-primary btn-sm btn-icon-split ms-1]

        def data = {
          controller: 'tooltip',
          'bs-custom-class': 'responsive-button-tooltip-lg',
          turbo: false
        }

        def title = t('.text')

        def path = '/auth/google_oauth2'

        def icon = :google

        def form = { class: 'd-inline' }

        def render? = google_sign_in_feature_flag
      end
    end
  end
end
