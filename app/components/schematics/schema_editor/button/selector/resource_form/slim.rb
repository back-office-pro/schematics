# frozen_string_literal: true

Schematics::SchemaEditor::Button::Selector::ResourceForm::SLIM = <<~SLIM
  span data-controller='tooltip' title=title
    button.btn.btn-sm.btn-primary.btn-icon-split.ms-1.schema-editor.collapse.collapse-horizontal.show {
      class=css_classes
      data-bs-toggle='collapse'
      data-bs-target='.resource-form'
    }
      span.icon = fa_icon(icon)
      span.text.text-nowrap.d-none.d-lg-inline = t('.title')
SLIM
