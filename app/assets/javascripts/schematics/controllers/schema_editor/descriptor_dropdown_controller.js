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
    return document
      .querySelector(`span[data-bs-target="#${this.modalId}"]`)
      .closest('.schema-editor-entity')
      .querySelectorAll('.entity-field-name')
  }

  get modalId () {
    return this
      .element
      .closest('.modal')
      .getAttribute('id')
  }

  get collection () {
    return Array
      .from(this.inputs)
      .map(_ => _.value)
      .map(value => ({ value, text: value }))
      .sort((a, b) => a.text - b.text)
  }
}
