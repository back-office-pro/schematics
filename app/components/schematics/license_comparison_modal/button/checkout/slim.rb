# frozen_string_literal: true

Schematics::LicenseComparisonModal::Button::Checkout::SLIM = <<~SLIM
  = link_to website_url(path:), class: wrapper_css_classes, target:, rel: do
    span.icon = fa_icon icon
    span.text = title
SLIM
