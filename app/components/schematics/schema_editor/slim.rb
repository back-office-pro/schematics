# frozen_string_literal: true

Schematics::SchemaEditor::SLIM = <<~SLIM
  = bootstrap_form_with model: schema, scope: :migration, url:, class: css_classes, method: form_method, data: do |form|
    = __schema_editor_template_entity(form:)
    = __schema_editor_template_virtual(form:)
    = __schema_editor_template_trigger(form:)
    = __schema_editor_template_association_has_and_belongs_to_many(form:)
    = __schema_editor_template_attribute(attributes_collection, form:)
    = __schema_editor_template_attribute(:belongs_to_has_one, form:)
    = __schema_editor_errors(errors:)
    .row.g-3.pb-3#entities data-nested-form-target='targets'
      = form.fields_for :entities, entities do |builder|
        = __schema_editor_entity(builder:)
    = __button_confirm
    = __button_cancel(path: resource_path(resource))
SLIM
