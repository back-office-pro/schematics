# frozen_string_literal: true

Schematics::ResourceForm::Fields::String::SLIM = <<~SLIM
  - if translated?
    - available_locales.each do |locale|
      = form.text_field :"\#{name}_\#{locale}",
                        label: i18n_label(locale),
                        prepend:,
                        hide_label:,
                        required:,
                        control_class:,
                        maxlength:,
                        minlength:
  - else
    = form.text_field name.to_sym,
                      prepend:,
                      hide_label:,
                      control_class:,
                      maxlength:,
                      minlength:
SLIM
