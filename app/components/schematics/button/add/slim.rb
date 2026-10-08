# frozen_string_literal: true

Schematics::Button::Add::SLIM = <<~SLIM
  = link_to path, data:, class: css_classes, title: do
    span.icon = fa_icon :plus
    span.text.text-nowrap.d-none.d-lg-inline = title
SLIM
