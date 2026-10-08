# frozen_string_literal: true

Schematics::ResourceForm::Fields::OneTimePassword::SLIM = <<~SLIM
  .mb-3
    = form.label attribute_name, class: label_css_classes
    .input-group data-controller='one-time-password'
      - digits.times
        = form.text_field name,
                          hide_label:,
                          required:,
                          inputmode:,
                          control_class:,
                          autocomplete:,
                          multiple:,
                          wrapper_class:,
                          pattern:,
                          maxlength:,
                          data:
SLIM
