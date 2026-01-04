import ApplicationController from 'controllers/application_controller'

/* global Turbo, I18n, routes */

export default class extends ApplicationController {
  initialize () {
    this.search = this.debounce(this.search)
  }

  static get targets () {
    return ['input', 'history', 'results']
  }

  static get values () {
    return { highlight: { type: Boolean, default: true } }
  }

  onFocus () {
    if (this.#hasResults()) {
      this.showResults()
      this.hideHistory()
    } else {
      this.showHistory()
      this.hideResults()
    }
  }

  selectItem ({ params: { url } }) {
    Turbo.visit(url)
  }

  suggestionTemplate ({ _metadata: { descriptor, icon, url } }) {
    return `
      <li class="list-group-item list-group-item-action p-2 text-start text-truncate" data-action="mousedown->search-bar#selectItem" data-search-bar-url-param="${url}" role="button">
        <i class="fa fa-${icon} text-secondary me-2"></i>
        ${this.highlight(descriptor, this.inputTarget.value)}
      </li>
    `
  }

  notFoundTemplate () {
    return `
      <li class="list-group-item disabled p-2 text-start text-truncate">
        <i class="fa fa-exclamation-triangle text-secondary me-2"></i>
        ${I18n.typeahead.notFound}
      </li>
    `
  }

  pendingTemplate () {
    return `
      <li class="list-group-item disabled p-2 text-start text-truncate">
        <i class="fa fa-spinner fa-spin text-secondary me-2"></i>
        ${I18n.typeahead.pending}
      </li>
    `
  }

  highlight (source, mark) {
    if (this.highlightValue) {
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

  hideHistory () {
    this.historyTarget.classList.add('d-none')
  }

  showHistory () {
    this.historyTarget.classList.remove('d-none')
  }

  async search ({ key }) {
    if (this.#isValid()) {
      if (key === 'Enter') {
        this.hideHistory()
        this.hideResults()
      } else {
        this.showResults()
        this.hideHistory()
        this.resultsTarget.innerHTML = this.pendingTemplate()
        const response = await this.fetchAPI(this.url, 'POST', this.params)
        const results = await response.json()
        this.resultsTarget.innerHTML = (results.length === 0)
          ? this.notFoundTemplate()
          : results.map(this.suggestionTemplate.bind(this)).join('')
      }
    } else {
      this.clearResults()
      this.showHistory()
    }
  }

  #hasResults () {
    return this.resultsTarget.innerHTML !== ''
  }

  #isValid () {
    return this.inputTarget.value.length >= this.inputTarget.getAttribute('minlength')
  }

  get url () {
    return routes.searches
  }

  get params () {
    return { autocompletion: { query: this.inputTarget.value } }
  }
}
