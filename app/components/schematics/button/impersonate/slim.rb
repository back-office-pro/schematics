# frozen_string_literal: true

Schematics::Button::Impersonate::SLIM = <<~SLIM
  = button_to sessions_path, method: :post, params:, data:, class: css_classes, title:, form: do
    span.icon = fa_icon :people_arrows_left_right
    span.icon.d-none = fa_icon :spinner, animation: 'spin'
    span.text.d-none.d-xxl-inline = title
    span.text.d-none = t('.loading')
SLIM
