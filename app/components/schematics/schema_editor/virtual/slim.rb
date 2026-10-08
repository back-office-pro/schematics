# frozen_string_literal: true

Schematics::SchemaEditor::Virtual::SLIM = <<~SLIM
  .col-xl-6.col-md-12.schema-editor-virtual.cursor-grab
    .card.shadow-sm
      .card-header.px-2.py-1.bg-body-tertiary
        .row.align-items-center
          .col.text-truncate.px-0
            = __card_heading(icon:, title:)
          .col-auto
            .btn-group
              = __schema_editor_button_options(builder:)
              = __schema_editor_button_remove(wrapper: '.schema-editor-virtual')
      .card-body
        = builder.hidden_field :id
        = builder.text_field :name, maxlength: 50, class: 'entity-field-name', data: { controller: 'schema-editor--special-characters' }
        = builder.text_field(:function, data:)
        = __schema_editor_options_modal(builder:)
SLIM
