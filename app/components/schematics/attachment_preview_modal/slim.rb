# Copyright © 2025 Dev & Software. All rights reserved.

# THIS SOFTWARE IS PROPRIETARY AND CONFIDENTIAL. UNAUTHORIZED COPYING, DISTRIBUTION, MODIFICATION,
# REVERSE ENGINEERING, OR DISCLOSURE IS STRICTLY PROHIBITED.
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT
# NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE, AND
# NONINFRINGEMENT.
# IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES, OR OTHER
# LIABILITY ARISING FROM, OUT OF, OR IN CONNECTION WITH THE SOFTWARE OR ITS USE.

# frozen_string_literal: true

Schematics::AttachmentPreviewModal::SLIM = <<~SLIM
  .modal.fade {
    id=target
    data-controller='modal'
    aria-hidden='true'
    tabindex='-1'
  }
    .modal-dialog.modal-dialog-centered.modal-lg
      .modal-content.shadow-sm
        .modal-header.pb-1
          = __card_heading(icon:, title: filename, modal_title: true)
          button.btn-close.me-1 aria-label='Close' data-bs-dismiss='modal' type='button'
        .modal-body.text-center
          = __attachment(attachment:, width: 800, height: 600, class: 'rounded')
        .modal-footer
          = link_to attachment, download: filename, class: 'btn btn-primary btn-sm btn-icon-split me-2' do
            span.icon = fa_icon :download
            span.text = t('.download')
          button.btn.btn-danger.btn-sm.btn-icon-split data-bs-dismiss='modal'
            span.icon = fa_icon :xmark
            span.text = t('.close')
SLIM
