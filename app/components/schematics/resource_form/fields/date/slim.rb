# frozen_string_literal: true

Schematics::ResourceForm::Fields::Date::SLIM = <<~SLIM
  = form.date_field name.to_sym, prepend:, hide_label:, control_class:
SLIM
