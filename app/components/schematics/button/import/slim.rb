# frozen_string_literal: true

Schematics::Button::Import::SLIM = <<~SLIM
  = link_to path, data:, class: css_classes, title: do
    span.icon = fa_icon(icon)
    span.text.d-none.d-lg-inline = title
SLIM
