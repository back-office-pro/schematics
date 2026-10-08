# frozen_string_literal: true

Schematics::ResourceForm::Fields::Url::SLIM = <<~SLIM
  = form.url_field name.to_sym, prepend:, hide_label:, control_class:, maxlength:, minlength:
SLIM
