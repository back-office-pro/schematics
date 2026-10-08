# frozen_string_literal: true

Schematics::Button::Emailing::SLIM = <<~SLIM
  span data-controller='tooltip' title=title
    = link_to path, data:, class: css_classes, title: do
      span.icon = fa_icon(icon)
      span.text.d-none.d-xxl-inline = t('.text')
SLIM
