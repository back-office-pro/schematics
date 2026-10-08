# frozen_string_literal: true

Schematics::Button::SSOSignIn::SLIM = <<~SLIM
  span data-controller='tooltip' data-bs-title=tooltip_title
    = button_to path, data:, class: css_classes, title:, form: do
      span.icon = fa_icon(icon)
      span.text.d-none.d-lg-inline = title
SLIM
