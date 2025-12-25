# Copyright © 2025 Dev & Software. All rights reserved.
#
# THIS SOFTWARE IS PROPRIETARY AND CONFIDENTIAL. UNAUTHORIZED COPYING, DISTRIBUTION, MODIFICATION,
# REVERSE ENGINEERING, OR DISCLOSURE IS STRICTLY PROHIBITED.
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT
# NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE, AND
# NONINFRINGEMENT.
# IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES, OR OTHER
# LIABILITY ARISING FROM, OUT OF, OR IN CONNECTION WITH THE SOFTWARE OR ITS USE.

# frozen_string_literal: false

Rails.configuration.after_initialize do
  Chartkick.options = {
    refresh: 60,
    html: Schematics::ChartPlaceholder::Component.new.to_html,
    content_for: :charts_js,
    library: {
      # Google Charts
      backgroundColor: 'transparent',
      # Charts.js
      animation: {
        duration: 1000,
        easing: 'easeOutQuad'
      },
      title: {
        font: {
          size: 12
        }
      },
      scales: {
        y: {
          title: {
            font: {
              size: 12
            }
          }
        },
        x: {
          title: {
            font: {
              size: 12
            }
          }
        }
      }
    }
  }
end
