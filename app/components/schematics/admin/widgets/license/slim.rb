# frozen_string_literal: true

Schematics::Admin::Widgets::License::SLIM = <<~SLIM
  .col-xl-3.col-md-6
    .card.widget.animate__animated.animate__zoomIn
      .card-body.p-3
        .row.g-0.align-items-center
          .col.text-center class=col_css_classes
            = fa_icon icon, size: '3x', class: 'd-inline-block text-primary'
            h5.text-primary.my-4
              = text
            - if expires_at
              .text-body-secondary.text-truncate
                span.me-1 = Schematics::License.human_attribute_name('expires_at')
                span = expires_at_formatted
            - else
              = __button_license_comparison
SLIM
