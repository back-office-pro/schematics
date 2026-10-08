# frozen_string_literal: true

Schematics::Button::Stale::SLIM = <<~SLIM
  = link_to version_path(last_version), data:, class: css_classes, title: do
    span.icon = fa_icon :triangle_exclamation
    span.text.d-none.d-lg-inline = title
SLIM
