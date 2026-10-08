# frozen_string_literal: true

Schematics::Button::Revert::SLIM = <<~SLIM
  = button_to revert_version_path(version), method: :patch, data:, class: css_classes, title: do
    span.icon = fa_icon :arrow_rotate_left
    span.icon.d-none = fa_icon :spinner, animation: 'spin'
    span.text.d-none.d-lg-inline = title
    span.text.d-none = t('.loading')
SLIM
