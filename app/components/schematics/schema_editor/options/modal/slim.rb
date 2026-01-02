# Copyright © 2025 Dev & Software. All rights reserved.

# THIS SOFTWARE IS PROPRIETARY AND CONFIDENTIAL. UNAUTHORIZED COPYING, DISTRIBUTION, MODIFICATION,
# REVERSE ENGINEERING, OR DISCLOSURE IS STRICTLY PROHIBITED.
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT
# NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE, AND
# NONINFRINGEMENT.
# IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES, OR OTHER
# LIABILITY ARISING FROM, OUT OF, OR IN CONNECTION WITH THE SOFTWARE OR ITS USE.

# frozen_string_literal: true

Schematics::SchemaEditor::Options::Modal::SLIM = <<~SLIM
  .modal.fade {
    id=target
    data-controller='modal'
    aria-hidden='true'
    tabindex='-1'
  }
    .modal-dialog.modal-dialog-centered
      .modal-content.shadow-sm
        .modal-header.pb-1.ps-1
          = __card_heading(icon:, title:, modal_title: true)
          button.btn-close aria-label='Close' data-bs-dismiss='modal' type='button'
        .modal-body
          = builder.fields_for :options do |options_form|
            - available_options.each do |option|
              = __schema_editor_options_inputs(:build, builder: options_form, object:, option:)
SLIM
