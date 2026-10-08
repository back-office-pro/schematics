import DropdownController from 'controllers/dropdown_controller'

export default class extends DropdownController {
  static get values () {
    return { url: { type: String }, field: { type: String } }
  }

  async #search (input, callback) {
    const url = `${this.urlValue}?filter[${this.fieldValue}]=${input}`
    const response = await this.fetchAPI(url)
    const results = await response.json()
    callback(results)
  }

  #isValid (input) {
    return this.element.options.length >= 100 && input.length >= 2
  }

  get options () {
    return Object.assign(super.options, {
      valueField: 'id',
      searchField: this.fieldValue,
      labelField: this.fieldValue,
      sortField: this.fieldValue,
      shouldLoad: this.#isValid.bind(this),
      load: this.#search.bind(this)
    })
  }
}
