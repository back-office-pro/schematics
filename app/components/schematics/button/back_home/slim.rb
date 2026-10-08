# frozen_string_literal: true

Schematics::Button::BackHome::SLIM = <<~SLIM
  = link_to root_path, class: css_classes do
    span.icon = fa_icon(icon)
    span.text = t('.text')
SLIM
