# frozen_string_literal: true

Schematics::Onboarding::SLIM = <<~SLIM
  .col-xl-6.col-md-12
    .card.animate__animated.animate__zoomIn
      .card-body.p-3.m-1
        .row.g-1.align-items-center
          .col-auto
            = __card_heading(icon:, title:)
          .col
            = __button_add(model_class:)
SLIM
