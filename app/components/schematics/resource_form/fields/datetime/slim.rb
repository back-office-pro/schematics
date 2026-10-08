# frozen_string_literal: true

Schematics::ResourceForm::Fields::Datetime::SLIM = <<~SLIM
  = form.datetime_field name.to_sym, prepend:, hide_label:, control_class:
SLIM
