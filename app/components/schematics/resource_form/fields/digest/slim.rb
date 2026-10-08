# frozen_string_literal: true

Schematics::ResourceForm::Fields::Digest::SLIM = <<~SLIM
  - inputs_count.times do |index|
    span data-controller='password'
      = form.password_field index.zero? ? name : :"\#{name}_confirmation",
                            required: required?,
                            autocomplete:,
                            'data-password-target': 'input',
                            prepend: fa_icon(icon),
                            append: eye_icons
SLIM
