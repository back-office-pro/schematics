# frozen_string_literal: true

Schematics::SchemaEditor::Trigger::SLIM = <<~SLIM
  .col-xl-6.col-md-12.schema-editor-trigger.cursor-grab
    .card.shadow-sm
      .card-header.px-2.py-1.bg-body-tertiary
        .row.align-items-center
          .col.text-truncate.px-0
            = __card_heading(icon:, title:)
          .col-auto
            = __schema_editor_button_remove(wrapper: '.schema-editor-trigger')
      .card-body
        = builder.hidden_field :id
        = builder.select :action, collection, { prompt: }, { required: true, data: { controller: 'dropdown' } }
        = builder.text_field :callback, data:
SLIM
