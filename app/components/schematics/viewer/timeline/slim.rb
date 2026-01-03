# Copyright © 2025 Dev & Software. All rights reserved.

# THIS SOFTWARE IS PROPRIETARY AND CONFIDENTIAL. UNAUTHORIZED COPYING, DISTRIBUTION, MODIFICATION,
# REVERSE ENGINEERING, OR DISCLOSURE IS STRICTLY PROHIBITED.
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT
# NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE, AND
# NONINFRINGEMENT.
# IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES, OR OTHER
# LIABILITY ARISING FROM, OUT OF, OR IN CONNECTION WITH THE SOFTWARE OR ITS USE.

# frozen_string_literal: true

Schematics::Viewer::Timeline::SLIM = <<~SLIM
  = turbo_frame_tag 'timeline', data: { turbo_action: 'advance' } do
    .row.justify-content-center.mt-4
      .col-xl-9.col-md-12.position-relative
        ul.timeline.list-unstyled
          - @versions.each do |version|
            li
              .timeline-icon.bg-primary
                = fa_icon version.icon, size: '2x', class: 'text-white'
              .card.animate__animated.animate__zoomIn
                .card-body.p-3
                  = __version_preview(version:)
    = __viewer_pagination(pagy: @pagy)
SLIM
