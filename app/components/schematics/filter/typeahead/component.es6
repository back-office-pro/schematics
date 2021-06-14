/* global $, SearchBarController, Turbolinks */

window.TypeaheadController = class extends SearchBarController {
  onSearch () {
    const scope = this.inputTarget.getAttribute('name')
    const searchParams = new URLSearchParams(window.location.search)
    if (searchParams.has(scope)) {
      searchParams.delete(scope)
      Turbolinks.visit(window.location.pathname + '?' + searchParams)
    } else {
      super.onSearch()
    }
  }

  formatResults (results) {
    return results
  }

  selectItem (event) {
    this.inputTarget.value = event.currentTarget.dataset.value
    $(this.inputTarget.form).submit()
  }

  suggestionTemplate (result) {
    return `
      <li class="list-group-item p-2 border-0 text-left text-truncate" data-action="mousedown->typeahead#selectItem" data-value="${result}" role="button">
        <i class="fa fa-search text-dark fa-fw mr-2"></i>
        ${this.highlight(result, this.inputTarget.value)}
      </li>
    `
  }

  getUrl () {
    const scope = this.inputTarget.getAttribute('name')
    const element = scope.match(/filter\[(\w+)\]/)[1]
    const searchParams = new URLSearchParams(window.location.search)
    searchParams.delete('page')
    searchParams.delete('per_page')
    searchParams.delete('sort')
    searchParams.set('field', element)
    searchParams.set(scope, decodeURI(this.inputTarget.value))
    searchParams.set('sort', element)
    return `${window.location.pathname}/autocomplete?${searchParams}`
  }
}
