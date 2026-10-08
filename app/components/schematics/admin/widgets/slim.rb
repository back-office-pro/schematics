# frozen_string_literal: true

Schematics::Admin::Widgets::SLIM = <<~SLIM
  .col-xl-3.col-md-6
    .card.widget.animate__animated.animate__zoomIn
      .card-body.p-3
        .row.g-0.align-items-center
          .col.text-center.p-4
            = link_to path, class: 'text-decoration-none' do
              = fa_icon icon, size: '3x', class: 'd-inline-block'
              h5.my-4 = title
              .text-body-secondary.text-truncate = caption
SLIM
