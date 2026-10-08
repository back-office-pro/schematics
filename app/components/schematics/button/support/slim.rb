# frozen_string_literal: true

Schematics::Button::Support::SLIM = <<~SLIM
  = mail_to email, class: wrapper_css_classes do
    span.icon = fa_icon icon, class: icon_css_classes
    span.text = t('.text')
SLIM
