# frozen_string_literal: true

Schematics::Button::Draft::SLIM = <<~SLIM
  button.btn.btn-sm.btn-icon-split.bg-body-tertiary.ms-1.d-none {
    data-controller='tooltip'
    data-auto-save-target='button'
    data-bs-custom-class='responsive-button-tooltip-lg'
    data-bs-title=title
  }
    span.icon = fa_icon(icon)
    span.text.d-none.d-lg-inline
      = title
      span.timeago.ms-1 data-controller='timeago'
SLIM
