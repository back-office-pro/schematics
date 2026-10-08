# frozen_string_literal: true

Schematics::Button::Cancel::SLIM = <<~SLIM
  = link_to path, data:, class: css_classes, title: do
    span.icon = fa_icon :xmark
    span.text = title unless compact?
SLIM
