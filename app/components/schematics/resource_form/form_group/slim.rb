# frozen_string_literal: true

Schematics::ResourceForm::FormGroup::SLIM = <<~SLIM
  - if group
    .accordion.shadow-sm.mb-3.animate__animated.animate__zoomIn.rounded-bottom
      .accordion-item
        .accordion-header
          button.accordion-button.py-1.pe-3.ps-1.bg-body-tertiary {
            type='button'
            data-bs-toggle='collapse'
            data-bs-target="#\#{id}"
            aria-expanded='true'
            aria-controls=id
          }
            = __card_heading(icon:, title:)
        .accordion-collapse.collapse.show id=id
          .accordion-body.pb-1
            = body
  - else
    = body
SLIM
