# frozen_string_literal: true

Schematics::SchemaEditor::Template::Attribute::SLIM = <<~SLIM
  template id="schema-editor-attribute-\#{@slug}" data-nested-form-target='templates'
    = @form.fields_for :entities, entity, child_index: 'INDEX' do |entity_builder|
      = entity_builder.fields_for :attributes, attribute, child_index: 'NEW_RECORD' do |builder|
        = __schema_editor_attribute(builder:)
SLIM
