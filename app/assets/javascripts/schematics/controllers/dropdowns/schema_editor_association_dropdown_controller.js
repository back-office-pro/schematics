import SchemaEditorDescriptorDropdownController from './schema_editor_descriptor_dropdown_controller'

export default class extends SchemaEditorDescriptorDropdownController {
  get inputs () {
    return this
      .element
      .closest('form')
      .querySelectorAll('.schema_dataset_entities_name input')
  }
}
