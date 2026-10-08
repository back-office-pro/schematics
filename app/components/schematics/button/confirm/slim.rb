# frozen_string_literal: true

Schematics::Button::Confirm::SLIM = <<~SLIM
  = button_tag data:, class: css_classes, title: do
    span.icon = fa_icon :check
    span.icon.d-none = fa_icon :spinner, animation: 'spin'
    span.text = title unless compact?
    span.text.d-none = t('.loading') unless compact?
SLIM
