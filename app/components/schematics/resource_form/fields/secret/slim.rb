# frozen_string_literal: true

Schematics::ResourceForm::Fields::Secret::SLIM = <<~SLIM
  = form.text_field name.to_sym, prepend:, hide_label:, control_class:
SLIM
