# Copyright © 2025 Dev & Software. All rights reserved.

# THIS SOFTWARE IS PROPRIETARY AND CONFIDENTIAL. UNAUTHORIZED COPYING, DISTRIBUTION, MODIFICATION,
# REVERSE ENGINEERING, OR DISCLOSURE IS STRICTLY PROHIBITED.
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT
# NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE, AND
# NONINFRINGEMENT.
# IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES, OR OTHER
# LIABILITY ARISING FROM, OUT OF, OR IN CONNECTION WITH THE SOFTWARE OR ITS USE.

# frozen_string_literal: true

Schematics::Button::DestroyAttachment::SLIM = <<~SLIM
  = form_with model: record, url: do |f|
    = f.fields_for attributes_param_key do |fields|
      = fields.hidden_field :id, value: attachment.id
      = fields.hidden_field :_destroy, value: true
    = __confirm_dialog(target:)
  button.btn.btn-danger.btn-sm.float-end {
    data-bs-toggle='modal'
    data-bs-target="#\#{target}"
    data-controller='tooltip'
    data-bs-placement='left'
    data-bs-title=title
  } = fa_icon :trash
SLIM
