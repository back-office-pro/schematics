# frozen_string_literal: true

Schematics::SchemaEditor::Options::Inputs::Boolean::SLIM = <<~SLIM
  = builder.checkbox option_name, { switch: true }, 'true', 'false'
SLIM
