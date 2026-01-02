# Copyright © 2025 Dev & Software. All rights reserved.

# THIS SOFTWARE IS PROPRIETARY AND CONFIDENTIAL. UNAUTHORIZED COPYING, DISTRIBUTION, MODIFICATION,
# REVERSE ENGINEERING, OR DISCLOSURE IS STRICTLY PROHIBITED.
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT
# NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE, AND
# NONINFRINGEMENT.
# IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES, OR OTHER
# LIABILITY ARISING FROM, OUT OF, OR IN CONNECTION WITH THE SOFTWARE OR ITS USE.

# frozen_string_literal: true

Schematics::Button::RestoreDraft::SLIM = <<~SLIM
  button.btn.btn-primary.btn-sm.btn-icon-split.ms-1 {
    data-auto-save-target='restoreButton'
    data-action='click->auto-save#restore'
    data-controller='tooltip'
    data-bs-custom-class='responsive-button-tooltip-lg'
    data-bs-title=title
  }
    span.icon = fa_icon(icon)
    span.text.d-none.d-lg-inline
      = title
      span.ms-1 data-controller='timeago' datetime=updated_at
SLIM
