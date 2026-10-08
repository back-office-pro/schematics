# frozen_string_literal: true

Schematics::SchemaEditor::Trigger::Popover::SLIM = <<~SLIM
  = __schema_editor_virtual_popover do |c|
    - c.with_row do
      tr
        th = t('.assignment')
        td = '+= -= *= ='
SLIM
