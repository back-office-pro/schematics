# frozen_string_literal: true

Schematics::Admin::Widgets::SoftwareUpdate::SLIM = <<~SLIM
  .col-xl-3.col-md-6
    .card.widget.animate__animated.animate__zoomIn
      .card-body.p-3
        .row.g-0.align-items-center
          .col.text-center.p-4 data-controller='software-update' data-software-update-version-value=version
            = link_to url, class: 'text-decoration-none' do
              = fa_icon icon, size: '3x', animation: 'spin', class: 'd-inline-block', data:
              h5.my-4 data-software-update-target='text'
                = t('.loading')
              .text-body-secondary.text-truncate = version
SLIM
