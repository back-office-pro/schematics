# frozen_string_literal: true

Schematics::SchemaEditor::Template::Virtual::SLIM = <<~SLIM
  template#schema-editor-virtual data-nested-form-target='templates'
    = form.fields_for :entities, entity, child_index: 'INDEX' do |entity_builder|
      = entity_builder.fields_for :virtuals, virtual, child_index: 'NEW_RECORD' do |builder|
        = __schema_editor_virtual(builder:)
SLIM
