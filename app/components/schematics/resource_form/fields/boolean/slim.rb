# frozen_string_literal: true

Schematics::ResourceForm::Fields::Boolean::SLIM = <<~SLIM
  = form.checkbox name.to_sym, { switch:, hide_label:, wrapper_class: }, 'true', 'false'
SLIM
