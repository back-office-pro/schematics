# frozen_string_literal: true

Schematics::SchemaEditor::Template::Entity::SLIM = <<~SLIM
  template#schema-editor-entity data-nested-form-target='templates'
    = form.fields_for :entities, entity, child_index: 'INDEX' do |builder|
      = __schema_editor_entity(builder:)
SLIM
