# frozen_string_literal: true

Schematics::ResourceForm::Fields::Code::SLIM = <<~SLIM
  - if translated?
    - available_locales.each do |locale|
      .mb-3.w-100 data=wrapper_data
        = form.textarea :"\#{name}_\#{locale}",
                        label: i18n_label(locale),
                        hide_label:,
                        wrapper_class:,
                        control_class:,
                        data:,
                        required:
        .form-control data-code-editor-target='container'
  - else
    .mb-3.w-100 data=wrapper_data
      = form.textarea name.to_sym, hide_label:, wrapper_class:, control_class:, data:
      .form-control data-code-editor-target='container'
SLIM
