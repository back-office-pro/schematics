# frozen_string_literal: true

Schematics::Button::Clipboard::SLIM = <<~SLIM
  = button_tag class: css_classes, data: do
    span.icon = fa_icon(icon)
    span.text = t('.text')
SLIM
