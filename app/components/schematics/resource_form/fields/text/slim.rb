# frozen_string_literal: true

Schematics::ResourceForm::Fields::Text::SLIM = <<~SLIM
  - if translated?
    - available_locales.each do |locale|
      = form.textarea :"\#{name}_\#{locale}",
                      label: i18n_label(locale),
                      prepend:,
                      hide_label:,
                      required:,
                      control_class:,
                      maxlength:,
                      minlength:,
                      data:
  - else
    = form.textarea name.to_sym,
                    prepend:,
                    hide_label:,
                    control_class:,
                    maxlength:,
                    minlength:,
                    data:
SLIM
