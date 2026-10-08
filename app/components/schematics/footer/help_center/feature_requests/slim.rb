# frozen_string_literal: true

Schematics::Footer::HelpCenter::FeatureRequests::SLIM = <<~SLIM
  = link_to url, class: wrapper_css_classes, target:, rel: do
    = fa_icon icon, class: icon_css_classes
    = title
SLIM
