# frozen_string_literal: true

Schematics::ResourceForm::Fields::Color::SLIM = <<~SLIM
  = form.color_field name.to_sym, prepend:, hide_label:, control_class:
SLIM
