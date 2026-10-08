# frozen_string_literal: true

Schematics::Button::Calendar::SLIM = <<~SLIM
  = link_to resource_path(resource, format: :ics), data:, class: css_classes, title: do
    span.icon = fa_icon :calendar_days
    span.text.d-none.d-xxl-inline = title
SLIM
