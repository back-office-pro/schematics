/* global Stimulus, fetchAPI, Turbolinks, I18n */

window.SearchBarController = class extends Stimulus.Controller {
  static get targets () {
    return ['input', 'results']
  }

  selectItem (event) {
    Turbolinks.visit(event.currentTarget.dataset.url)
  }

  suggestionTemplate ({ data, descriptor, icon, url }) {
    return `
      <li class="list-group-item p-2 border-0 text-left text-truncate" data-action="mousedown->searchBar#selectItem" data-url="${url}" role="button">
        <i class="fa fa-${icon} text-dark fa-fw mr-2"></i>
        ${this.highlight(data[descriptor], this.inputTarget.value)}
      </li>
    `
  }

  notFoundTemplate () {
    return `
      <li class="list-group-item disabled p-2 border-0 text-left text-truncate">
        <i class="fa fa-exclamation-triangle text-dark fa-fw mr-2"></i>
        ${I18n.typeahead.not_found}
      </li>
    `
  }

  pendingTemplate () {
    return `
      <li class="list-group-item disabled p-2 border-0 text-left text-truncate">
        <i class="fa fa-spinner fa-spin text-dark fa-fw mr-2"></i>
        ${I18n.typeahead.pending}
      </li>
    `
  }

  highlight (source, mark) {
    if (this.data.get('highlight') === 'true') {
      return source.replace(new RegExp(`(${mark})`, 'i'), '<mark>$1</mark>')
    } else {
      return source
    }
  }

  clearResults () {
    this.resultsTarget.innerHTML = ''
  }

  hideResults () {
    this.resultsTarget.classList.add('d-none')
  }

  showResults () {
    this.resultsTarget.classList.remove('d-none')
  }

  get url () {
    return `/searches/${this.inputTarget.value}`
  }

  async search () {
    this.clearResults()
    if (this.inputTarget.checkValidity()) {
      this.resultsTarget.insertAdjacentHTML('afterbegin', this.pendingTemplate())
      const response = await fetchAPI(this.url)
      const results = await response.json()
      this.clearResults()
      if (Object.keys(results).length === 0) {
        this.resultsTarget.insertAdjacentHTML('afterbegin', this.notFoundTemplate())
      } else {
        Object.values(results).flat().forEach(result => {
          this.resultsTarget.insertAdjacentHTML('afterbegin', this.suggestionTemplate(result))
        })
      }
    }
  }
}
