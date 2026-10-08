# frozen_string_literal: true

Schematics::Button::LicenseComparison::SLIM = <<~SLIM
  .btn.btn-primary.btn-sm.btn-icon-split data-bs-toggle='modal' data-bs-target=target
    span.icon = fa_icon icon
    span.text = title
SLIM
