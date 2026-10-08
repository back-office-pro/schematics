# frozen_string_literal: true

Schematics::Button::Restore::SLIM = <<~SLIM
  = link_to restore_resource_path(resource), class: css_classes, title:, role:, data: do
    span.icon = fa_icon :trash_arrow_up
    span.icon.d-none = fa_icon :spinner, animation: 'spin'
SLIM
