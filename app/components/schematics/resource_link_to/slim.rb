# frozen_string_literal: true

Schematics::ResourceLinkTo::SLIM = <<~SLIM
  - if authorized?
    = link_to body || human_name_with_icon, path, class: css_classes, data:
  - else
    = body || human_name_with_icon
SLIM
