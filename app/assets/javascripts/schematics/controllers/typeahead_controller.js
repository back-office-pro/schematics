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
        <i class="fa fa-search text-secondary fa-fw me-2"></i>
        ${this.highlight(result, this.inputTarget.value)}
      </li>
    `
  }

  fetch () {
    const scope = this.inputTarget.getAttribute('name')
    const element = scope.match(/filter\[(\w+)\]/)[1]
    return this.fetchAPI(this.url, 'POST', {
      field: element,
      sort: element,
      [scope]: decodeURI(this.inputTarget.value)
    })
  }

  get url () {
    return `${window.location.pathname}/${routes.autocompletions}`
  }
}
