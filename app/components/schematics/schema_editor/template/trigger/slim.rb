# frozen_string_literal: true

Schematics::SchemaEditor::Template::Trigger::SLIM = <<~SLIM
  template#schema-editor-trigger data-nested-form-target='templates'
    = form.fields_for :entities, entity, child_index: 'INDEX' do |entity_builder|
      = entity_builder.fields_for :triggers, trigger, child_index: 'NEW_RECORD' do |builder|
        = __schema_editor_trigger(builder:)
SLIM
