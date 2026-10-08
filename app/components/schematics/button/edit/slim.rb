# frozen_string_literal: true

Schematics::Button::Edit::SLIM = <<~SLIM
  = link_to edit_resource_path(resource), title:, data:, class: css_classes do
    span.icon = fa_icon :pen_to_square
    span.text.d-none.d-xxl-inline = title unless compact?
SLIM
