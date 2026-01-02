# Copyright © 2025 Dev & Software. All rights reserved.

# THIS SOFTWARE IS PROPRIETARY AND CONFIDENTIAL. UNAUTHORIZED COPYING, DISTRIBUTION, MODIFICATION,
# REVERSE ENGINEERING, OR DISCLOSURE IS STRICTLY PROHIBITED.
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT
# NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE, AND
# NONINFRINGEMENT.
# IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES, OR OTHER
# LIABILITY ARISING FROM, OUT OF, OR IN CONNECTION WITH THE SOFTWARE OR ITS USE.

# frozen_string_literal: true

Schematics::ResourceForm::Fields::HasMany::SLIM = <<~SLIM
  = __resource_form_fields_has_many_button_add(field:)
  = __resource_form_fields_has_many_template(form:, field:)
  div id=id data-nested-form-target='targets'
    = form.fields_for name do |form|
      .accordion.shadow-sm.mb-3.animate__animated.animate__zoomIn.rounded-bottom
        .accordion-item
          .accordion-header
            button.accordion-button.collapsed.py-1.pe-3.ps-1.bg-body-tertiary {
              type='button'
              data-bs-toggle='collapse'
              data-bs-target="#\#{dom_id(form.object)}"
              aria-expanded='false'
              aria-controls=dom_id(form.object)
            }
              = __card_heading(icon:, title: form.object)
          .accordion-collapse.collapse id=dom_id(form.object)
            .accordion-body.pb-1
              = __resource_form_fields(elements, form:)
SLIM
