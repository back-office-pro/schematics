# frozen_string_literal: true

Schematics::SchemaEditor::Errors::SLIM = <<~SLIM
  .alert.alert-danger
    = fa_icon :triangle_exclamation, class: 'me-3'
    = messages
SLIM
