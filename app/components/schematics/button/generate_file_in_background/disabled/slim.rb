# frozen_string_literal: true

Schematics::Button::GenerateFileInBackground::Disabled::SLIM = <<~SLIM
  span data-controller='tooltip' data-bs-title=t('.title')
    a#generate-file-in-background-button.btn.btn-sm.btn-icon-split.bg-body-tertiary.ms-1.disabled
      span.icon = fa_icon(icon)
      span.text.d-none.d-lg-inline = title
SLIM
