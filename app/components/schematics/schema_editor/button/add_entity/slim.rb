# Copyright © 2025 Dev & Software. All rights reserved.

# THIS SOFTWARE IS PROPRIETARY AND CONFIDENTIAL. UNAUTHORIZED COPYING, DISTRIBUTION, MODIFICATION,
# REVERSE ENGINEERING, OR DISCLOSURE IS STRICTLY PROHIBITED.
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT
# NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE, AND
# NONINFRINGEMENT.
# IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES, OR OTHER
# LIABILITY ARISING FROM, OUT OF, OR IN CONNECTION WITH THE SOFTWARE OR ITS USE.

# frozen_string_literal: true

Schematics::SchemaEditor::Button::AddEntity::SLIM = <<~SLIM
  button.btn.btn-sm.btn-primary.btn-icon-split.ms-1.schema-editor.collapse.collapse-horizontal.show {
    data-action='click->nested-form#add:prevent'
    data-nested-form-template-id-param='schema-editor-entity'
    data-nested-form-target-id-param='entities'
    data-controller='tooltip'
    data-bs-custom-class='responsive-button-tooltip-lg'
    data-bs-title=title
  }
    span.icon = fa_icon :plus
    span.text.text-nowrap.d-none.d-lg-inline = title
SLIM
