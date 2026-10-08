# frozen_string_literal: true

Schematics::OneTimePasswordForm::SLIM = <<~SLIM
  - if qr_code
    .alert.alert-secondary
      = fa_icon :circle_info, class: 'me-3'
      = t('.info')
  = bootstrap_form_with model:, url:, scope: do |form|
    .text-center == qr_code&.as_svg(module_size: 4)
    = __resource_form_fields_one_time_password(form:, name: :otp_attempt_digits)
    = __button_confirm
    = __button_cancel(path: root_path)
SLIM
