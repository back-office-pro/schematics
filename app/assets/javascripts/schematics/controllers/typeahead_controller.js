import SearchBarController from 'controllers/search_bar_controller'

/* global routes */

export default class extends SearchBarController {
  onSearch () {
    this.inputTarget.form.requestSubmit()
  }

  selectItem ({ params: { value } }) {
    this.inputTarget.value = value
    this.onSearch()
  }

  suggestionTemplate (result) {
    return `
      <li class="list-group-item list-group-item-action p-2 text-start text-truncate" data-action="mousedown->typeahead#selectItem" data-typeahead-value-param="${result}" role="button">
        <i class="fa fa-search text-secondary me-2"></i>
        ${this.highlight(result, this.inputTarget.value)}
      </li>
    `
  }

  get url () {
    const searchParams = new URLSearchParams(window.location.search)
    searchParams.delete('page')
    searchParams.delete('limit')
    searchParams.delete('sort')
    searchParams.set(this.inputName, decodeURI(this.inputTarget.value))
    return `${window.location.pathname}/${routes.autocompletions}?${searchParams}`
  }

  get params () {
    return { autocompletion: { query: this.inputName.match(/filter\[(\w+)\]/)[1] } }
  }

  get inputName () {
    return this.inputTarget.getAttribute('name')
  }
}
