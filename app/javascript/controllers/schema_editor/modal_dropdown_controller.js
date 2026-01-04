import DropdownController from 'controllers/dropdown_controller'

export default class extends DropdownController {
  #setCollection () {
    if (this.inputs?.length) {
      this.element.tomselect.clearOptions()
      this.element.tomselect.addOptions(this.collection)
    }
  }

  get options () {
    return Object.assign(super.options, {
      onFocus: this.#setCollection.bind(this)
    })
  }

  get inputs () {
    return this
      .element
      .closest('.modal-body')
      ?.querySelectorAll('select[data-dropdown-create-value="true"] option:not([value=""])')
  }

  get collection () {
    return Array
      .from(this.inputs)
      .map(_ => _.value)
      .map(value => ({ value, text: value }))
      .sort((a, b) => a.value.localeCompare(b.value))
  }
}
