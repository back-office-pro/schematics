# frozen_string_literal: true

Schematics::SchemaEditor::Entity::SLIM = <<~SLIM
  .col-xl-4.col-md-6.schema-editor-entity
    .card.shadow-sm
      .card-header.px-2.py-1.bg-body-tertiary
        .row.align-items-center
          .col.text-truncate.px-0
            = __card_heading(icon:, title:)
          .col-auto
            .btn-group
              = __schema_editor_button_add_dropdown(builder:)
              = __schema_editor_button_options(builder:)
              = __schema_editor_button_remove(wrapper: '.schema-editor-entity')
      .card-body
        = builder.hidden_field :id
        = builder.text_field :name, floating: true, maxlength: 50, class: 'entity-name', data: { controller: 'schema-editor--special-characters' }
        = __schema_editor_options_modal(builder:)
    .row.g-3.mt-0 id="fields-\#{index}" data-controller='sortable' data-nested-form-target='targets'
      = builder.fields_for :attributes do |attributes_builder|
        = __schema_editor_attribute(builder: attributes_builder)
      = builder.fields_for :virtuals do |virtuals_builder|
        = __schema_editor_virtual(builder: virtuals_builder)
      = builder.fields_for :triggers do |triggers_builder|
        = __schema_editor_trigger(builder: triggers_builder)
      = builder.fields_for :has_and_belongs_to_many_associations do |habtm_associations_builder|
        = __schema_editor_association_has_and_belongs_to_many(builder: habtm_associations_builder)
SLIM
