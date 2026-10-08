# frozen_string_literal: true

Schematics::Button::QrCode::SLIM = <<~SLIM
  = link_to resource_path(resource, format: :svg), data:, class: css_classes, title: do
    span.icon = fa_icon :qrcode
    span.text.d-none.d-xxl-inline = title
SLIM
