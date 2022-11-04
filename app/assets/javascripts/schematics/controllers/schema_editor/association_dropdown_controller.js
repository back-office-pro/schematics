import DescriptorDropdownController from 'controllers/schema_editor/descriptor_dropdown_controller'

export default class extends DescriptorDropdownController {
  get inputs () {
    return this
      .element
      .closest('form')
      .querySelectorAll('.schema_dataset_entities_name input')
  }
}
