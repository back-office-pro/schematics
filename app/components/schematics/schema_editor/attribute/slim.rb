# frozen_string_literal: true

Schematics::SchemaEditor::Attribute::SLIM = <<~SLIM
  .col-xl-6.col-md-12.schema-editor-attribute.cursor-grab
    .card.shadow-sm
      .card-header.px-2.py-1.bg-body-tertiary
        .row.align-items-center
          .col.text-truncate.px-0
            = __card_heading(icon:, title:)
          .col-auto
            .btn-group
              = __schema_editor_button_options(builder:)
              = __schema_editor_button_remove(wrapper: '.schema-editor-attribute')
      .card-body
        = builder.hidden_field :id
        - case builder.object
        - when Schematics::Attributes::BelongsTo
          = builder.select :name,
                           allowed_association_types,
                           { prompt: },
                           { required: true, data: { controller: 'schema-editor--association-dropdown' } }
        - else
          = builder.text_field :name, maxlength: 50, class: 'entity-field-name', data: { controller: 'schema-editor--special-characters' }
        = builder.select :type, collection, {}, { required: true, data: { controller: 'dropdown' } }
        = __schema_editor_options_modal(builder:)
SLIM
