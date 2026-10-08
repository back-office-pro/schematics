# frozen_string_literal: true

Schematics::Viewer::Association::Button::SLIM = <<~SLIM
  = link_to resources_path(klass, filter:), data:, class: css_classes, title: do
    = fa_icon(icon)
SLIM
