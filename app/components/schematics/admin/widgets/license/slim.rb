# Copyright © 2025 Dev & Software. All rights reserved.

# THIS SOFTWARE IS PROPRIETARY AND CONFIDENTIAL. UNAUTHORIZED COPYING, DISTRIBUTION, MODIFICATION,
# REVERSE ENGINEERING, OR DISCLOSURE IS STRICTLY PROHIBITED.
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT
# NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE, AND
# NONINFRINGEMENT.
# IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES, OR OTHER
# LIABILITY ARISING FROM, OUT OF, OR IN CONNECTION WITH THE SOFTWARE OR ITS USE.

# frozen_string_literal: true

Schematics::Admin::Widgets::License::SLIM = <<~SLIM
  .col-xl-3.col-md-6
    .card.animate__animated.animate__zoomIn
      .card-body.p-3
        .row.g-0.align-items-center
          .col.text-center class=col_css_classes
            = fa_icon icon, size: '3x', class: 'd-inline-block text-primary'
            h5.text-primary.my-4
              = text
            - if expires_at
              .text-body-secondary.text-truncate
                span.me-1 = Schematics::License.human_attribute_name('expires_at')
                span = expires_at_formatted
            - else
              = __button_license_comparison
SLIM
