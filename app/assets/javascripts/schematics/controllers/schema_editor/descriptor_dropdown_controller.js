import DropdownController from 'controllers/dropdown_controller'

export default class extends DropdownController {
  setCollection () {
    this.element.tomselect.clearOptions()
    this.element.tomselect.addOptions(this.collection)
  }

  get options () {
    return Object.assign(super.options, {
      onFocus: this.setCollection.bind(this)
    })
  }

  get inputs () {
    return this
      .element
      .closest('.schema-editor-entity')
      .querySelectorAll('.entity_field_name')
  }

  get collection () {
    return Array
      .from(this.inputs)
      .map(_ => _.value)
      .map(value => ({ value, text: value }))
      .sort((a, b) => a.text - b.text)
  }
}
