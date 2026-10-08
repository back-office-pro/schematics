# frozen_string_literal: true

Schematics::SchemaEditor::Button::AddEntity::SLIM = <<~SLIM
  button.btn.btn-sm.btn-primary.btn-icon-split.ms-1.schema-editor.collapse.collapse-horizontal.show {
    data-action='click->nested-form#add:prevent'
    data-nested-form-template-id-param='schema-editor-entity'
    data-nested-form-target-id-param='entities'
    data-controller='tooltip'
    data-bs-custom-class='responsive-button-tooltip-lg'
    data-bs-title=title
  }
    span.icon = fa_icon :plus
    span.text.text-nowrap.d-none.d-lg-inline = title
SLIM
