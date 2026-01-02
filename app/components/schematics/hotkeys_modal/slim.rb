# Copyright © 2025 Dev & Software. All rights reserved.

# THIS SOFTWARE IS PROPRIETARY AND CONFIDENTIAL. UNAUTHORIZED COPYING, DISTRIBUTION, MODIFICATION,
# REVERSE ENGINEERING, OR DISCLOSURE IS STRICTLY PROHIBITED.
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT
# NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE, AND
# NONINFRINGEMENT.
# IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES, OR OTHER
# LIABILITY ARISING FROM, OUT OF, OR IN CONNECTION WITH THE SOFTWARE OR ITS USE.

# frozen_string_literal: true

Schematics::HotkeysModal::SLIM = <<~SLIM
  #hotkeys-modal.modal.fade aria-hidden='true' tabindex='-1'
    .modal-dialog.modal-dialog-centered
      .modal-content.shadow-sm
        .modal-header.pb-1
          = __card_heading(icon:, title:, modal_title: true)
          button.btn-close.me-1 aria-label='Close' data-bs-dismiss='modal' type='button'
        .modal-body
          - groups.each do |group|
            .row.g-0
              - group.each do |(hotkey, title)|
                .col-2.text-nowrap.text-center
                  .badge.bg-primary.me-1 ctrl
                  .badge.bg-primary = hotkey
                .col-4 = title
SLIM
