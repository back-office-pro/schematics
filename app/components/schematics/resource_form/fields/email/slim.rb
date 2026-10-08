# frozen_string_literal: true

Schematics::ResourceForm::Fields::Email::SLIM = <<~SLIM
  = form.email_field name.to_sym, prepend:, hide_label:, control_class:, maxlength:, minlength:
SLIM
