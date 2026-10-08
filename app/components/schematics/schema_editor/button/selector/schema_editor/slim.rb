# frozen_string_literal: true

Schematics::SchemaEditor::Button::Selector::SchemaEditor::SLIM = <<~SLIM
  button.btn.btn-sm.btn-primary.btn-icon-split.ms-1.resource-form.collapse.collapse-horizontal {
    data-bs-toggle='collapse'
    data-bs-target='.schema-editor'
  }
    span.icon = fa_icon(icon)
    span.text.text-nowrap.d-none.d-lg-inline = title
SLIM
