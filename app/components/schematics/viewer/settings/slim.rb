# Copyright © 2025 Dev & Software. All rights reserved.

# THIS SOFTWARE IS PROPRIETARY AND CONFIDENTIAL. UNAUTHORIZED COPYING, DISTRIBUTION, MODIFICATION,
# REVERSE ENGINEERING, OR DISCLOSURE IS STRICTLY PROHIBITED.
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT
# NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE, AND
# NONINFRINGEMENT.
# IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES, OR OTHER
# LIABILITY ARISING FROM, OUT OF, OR IN CONNECTION WITH THE SOFTWARE OR ITS USE.

# frozen_string_literal: true

Schematics::Viewer::Settings::SLIM = <<~SLIM
  .btn-group.col-1.d-flex.position-static data-controller='viewer-settings'
    .dropdown.position-static data-controller='tooltip' data-bs-title=title
      a#settings-dropdown.btn.btn-sm.bg-body-tertiary.dropdown-toggle {
        data-bs-toggle='dropdown'
        data-bs-auto-close='outside'
        aria-expanded='false'
        role='button'
      }
        = fa_icon :ellipsis_vertical
      .dropdown-menu.shadow-sm.dropdown-menu-start.animate__animated.animate__zoomIn.p-0 {
        aria-labelledby='settings-dropdown'
      }
        h5.dropdown-header.rounded-top.bg-body-tertiary.fw-bold
          = title
        - if can?(:archive, model_class)
          .dropdown-item
            = __filter_checkbox(field: :with_deleted)
        = __viewer_settings_toggle(listable_elements.stable_sort_by(&:weight))
    = __viewer_settings_button(other_viewers, entity:)
SLIM
