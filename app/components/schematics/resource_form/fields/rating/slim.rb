# frozen_string_literal: true

Schematics::ResourceForm::Fields::Rating::SLIM = <<~SLIM
  = form.range_field name.to_sym, prepend:, hide_label:, control_class:, step:, min:, max:
SLIM
