# frozen_string_literal: true

Schematics::Button::RestoreDraft::SLIM = <<~SLIM
  button.btn.btn-primary.btn-sm.btn-icon-split.ms-1 {
    data-auto-save-target='restoreButton'
    data-action='click->auto-save#restore'
    data-controller='tooltip'
    data-bs-custom-class='responsive-button-tooltip-lg'
    data-bs-title=title
  }
    span.icon = fa_icon(icon)
    span.text.d-none.d-lg-inline
      = title
      span.ms-1 data-controller='timeago' datetime=updated_at
SLIM
