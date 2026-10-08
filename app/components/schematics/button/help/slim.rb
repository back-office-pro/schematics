# frozen_string_literal: true

Schematics::Button::Help::SLIM = <<~SLIM
  = link_to url, data:, class: wrapper_css_classes, title:, target:, rel: do
    span.icon = fa_icon icon, class: icon_css_classes
    span.text class=text_css_classes = title
SLIM
