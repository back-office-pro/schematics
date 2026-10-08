# frozen_string_literal: true

Schematics::Button::Comment::SLIM = <<~SLIM
  button.btn.btn-primary.btn-sm.btn-icon-split.ms-1.position-relative {
    data-controller='tooltip'
    data-bs-toggle='offcanvas'
    data-bs-target='#comments'
    data-bs-title=title
    data-bs-custom-class='responsive-button-tooltip-xxl'
  }
    - if count.positive?
      .badge.bg-danger.rounded-pill.position-absolute.top-0.start-100.translate-middle.animate__animated.animate__zoomIn
        = display_count
    span.icon = fa_icon(icon)
    span.text.d-none.d-xxl-inline = title
SLIM
