# frozen_string_literal: true

Schematics::ResourceForm::Fields::Numerable::SLIM = <<~SLIM
  = form.number_field name.to_sym, prepend:, hide_label:, control_class:, step:, min:, max:
SLIM
