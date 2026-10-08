# frozen_string_literal: true

Schematics::CardHeading::SLIM = <<~SLIM
  h6 class=css_classes
    = fa_icon icon, class: 'mx-2 fa-lg align-middle' if icon
    span.align-middle = title
SLIM
