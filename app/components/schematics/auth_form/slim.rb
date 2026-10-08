# frozen_string_literal: true

Schematics::AuthForm::SLIM = <<~SLIM
  = bootstrap_form_with model:, scope:, url: do |form|
    = form.email_field :email,
                       autocomplete: 'username',
                       autofocus: true,
                       prepend: fa_icon(:envelope)
    = __resource_form_fields_digest(form:)
    = form.checkbox :remember_me, switch: true
    = __button_confirm
    = __button_password_lost
SLIM
