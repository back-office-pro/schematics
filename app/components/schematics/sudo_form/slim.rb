# frozen_string_literal: true

Schematics::SudoForm::SLIM = <<~SLIM
  .alert.alert-danger
    = fa_icon :triangle_exclamation, class: 'me-3'
    = t('.warning')
  = bootstrap_form_with model:, url: do |form|
    = __resource_form_fields_digest(form:)
    = __button_confirm
    = __button_cancel(path: root_path)
SLIM
