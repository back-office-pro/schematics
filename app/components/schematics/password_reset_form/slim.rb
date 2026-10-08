# frozen_string_literal: true

Schematics::PasswordResetForm::SLIM = <<~SLIM
  = bootstrap_form_with model:, url: do |form|
    = form.email_field :email, prepend: fa_icon(:envelope)
    = __button_confirm
    = __button_cancel(path: login_path)
SLIM
