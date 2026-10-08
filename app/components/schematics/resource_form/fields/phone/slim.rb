# frozen_string_literal: true

Schematics::ResourceForm::Fields::Phone::SLIM = <<~SLIM
  = form.phone_field name.to_sym, prepend:, hide_label:, control_class:, maxlength:, minlength:
SLIM
