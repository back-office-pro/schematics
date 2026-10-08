# frozen_string_literal: true

Schematics::SchemaEditor::Options::Inputs::Select::SLIM = <<~SLIM
  = builder.select option_name,
                   collection,
                   { selected:, include_hidden:, include_blank: }.compact,
                   { multiple: multiple?, data: }
SLIM
