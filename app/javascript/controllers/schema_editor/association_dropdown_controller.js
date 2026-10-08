import DropdownController from 'controllers/dropdown_controller'

export default class extends DropdownController {
  initialize () {
    super.initialize()
    this.initialCollection = this.element.tomselect.options
  }

  #setCollection () {
    this.element.tomselect.clearOptions()
    this.element.tomselect.addOptions(this.initialCollection)
    this.element.tomselect.addOptions(this.collection)
  }

  get options () {
    return Object.assign(super.options, {
      onFocus: this.#setCollection.bind(this),
      sortField: 'value'
    })
  }

  get inputs () {
    return document.querySelectorAll('.entity-name')
  }

  get collection () {
    return Array
      .from(this.inputs)
      .map(_ => _.value)
      .map(value => ({ value, text: value }))
  }
}
