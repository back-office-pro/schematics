# frozen_string_literal: true

Schematics::SchemaEditor::Options::Inputs::Array::SLIM = <<~SLIM
  = builder.select option_name,
                   values,
                   { include_hidden:, include_blank: },
                   { multiple: true, data: }
SLIM
