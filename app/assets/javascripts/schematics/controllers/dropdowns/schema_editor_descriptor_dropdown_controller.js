import DropdownController from 'controllers/dropdown_controller'

export default class extends DropdownController {
  setCollection () {
    const selected = this.element.slim.selected()
    this.element.slim.setData(this.collection)
    this.element.slim.set(selected)
  }

  get options () {
    return Object.assign(super.options, {
      beforeOpen: this.setCollection.bind(this)
    })
  }

  get inputs () {
    return this
      .element
      .closest('.schema-editor-entity')
      .querySelectorAll('.schema_dataset_entities_attributes_name input, .schema_dataset_entities_virtuals_name input')
  }

  get collection () {
    return Array
      .from(this.inputs)
      .map(input => ({ value: input.value, text: input.value }))
      .sort((a, b) => a.text - b.text)
  }
}
