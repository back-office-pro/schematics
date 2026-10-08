# frozen_string_literal: true

Schematics::Button::DestroyOTP::SLIM = <<~SLIM
  = button_to one_time_passwords_path, method: :delete, data:, class: css_classes, title:, form: do
    span.icon = fa_icon :toggle_off
    span.icon.d-none = fa_icon :spinner, animation: 'spin'
    span.text.d-none.d-lg-inline = title
    span.text.d-none = t('.loading')
SLIM
