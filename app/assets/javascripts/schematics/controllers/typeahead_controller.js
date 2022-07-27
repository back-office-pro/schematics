import SearchBarController from './search_bar_controller'

export default class extends SearchBarController {
  onSearch () {
    this.inputTarget.form.requestSubmit()
  }

  formatResults (results) {
    return results
  }

  selectItem ({ params: { value } }) {
    this.inputTarget.value = value
    this.onSearch()
  }

  suggestionTemplate (result) {
    return `
      <li class="list-group-item list-group-item-action p-2 border-0 text-start text-truncate" data-action="mousedown->typeahead#selectItem" data-typeahead-value-param="${result}" role="button">
        <i class="fa fa-search text-secondary fa-fw me-2"></i>
        ${this.highlight(result, this.inputTarget.value)}
      </li>
    `
  }

  get url () {
    const scope = this.inputTarget.getAttribute('name')
    const element = scope.match(/filter\[(\w+)\]/)[1]
    const searchParams = new URLSearchParams(window.location.search)
    searchParams.delete('page')
    searchParams.delete('items')
    searchParams.delete('sort')
    searchParams.set('field', element)
    searchParams.set(scope, decodeURI(this.inputTarget.value))
    searchParams.set('sort', element)
    return `${window.location.pathname}/autocomplete?${searchParams}`
  }
}
