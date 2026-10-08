# frozen_string_literal: true

Schematics::Viewer::ResourceLink::SLIM = <<~SLIM
  = content_tag(tag_name, class: css_classes, data:, role:) do
    = body
SLIM
