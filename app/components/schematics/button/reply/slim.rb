# frozen_string_literal: true

Schematics::Button::Reply::SLIM = <<~SLIM
  = link_to new_message_reply_path(resource), title:, data:, class: css_classes do
    span.icon = fa_icon :reply
    span.text.d-none.d-xxl-inline = title
SLIM
