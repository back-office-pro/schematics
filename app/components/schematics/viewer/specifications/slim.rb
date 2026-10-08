# frozen_string_literal: true

Schematics::Viewer::Specifications::SLIM = <<~SLIM
  .card.shadow-sm.animate__animated.animate__zoomIn
    .card-header.px-1.py-2
      = __card_heading(icon:, title:)
    .card-body.p-0
      = __viewer_specifications_entity(entities)
SLIM
