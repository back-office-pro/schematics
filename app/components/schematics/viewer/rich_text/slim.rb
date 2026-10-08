# frozen_string_literal: true

Schematics::Viewer::RichText::SLIM = <<~SLIM
  .accordion.shadow-sm.mt-3.animate__animated.animate__zoomIn.rounded-bottom
    .accordion-item
      .accordion-header
        button.accordion-button.py-1.pe-3.ps-1 {
          type='button'
          data-bs-toggle='collapse'
          data-bs-target="#\#{id}"
          aria-expanded='true'
          aria-controls=id
        }
          = __card_heading(icon:, title:)
      .accordion-collapse.collapse.show id=id
        .accordion-body
          == value
SLIM
