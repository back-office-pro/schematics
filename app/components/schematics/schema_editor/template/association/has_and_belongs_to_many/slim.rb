# frozen_string_literal: true

Schematics::SchemaEditor::Template::Association::HasAndBelongsToMany::SLIM = <<~SLIM
  template#schema-editor-habtm-association data-nested-form-target='templates'
    = form.fields_for :entities, entity, child_index: 'INDEX' do |entity_builder|
      = entity_builder.fields_for :has_and_belongs_to_many_associations, association, child_index: 'NEW_RECORD' do |builder|
        = __schema_editor_association_has_and_belongs_to_many(builder:)
SLIM
