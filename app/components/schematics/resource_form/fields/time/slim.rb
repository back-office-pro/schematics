# frozen_string_literal: true

Schematics::ResourceForm::Fields::Time::SLIM = <<~SLIM
  = form.time_field name.to_sym, prepend:, hide_label:, control_class:
SLIM
