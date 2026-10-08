# frozen_string_literal: true

Schematics::Footer::HelpCenter::PrivacyPolicy::SLIM = <<~SLIM
  = link_to website_url(path:), class: wrapper_css_classes, target:, rel: do
    = fa_icon icon, class: icon_css_classes
    = title
SLIM
