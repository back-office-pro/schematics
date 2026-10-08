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
