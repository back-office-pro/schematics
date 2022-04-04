import { Controller } from '../@hotwired/stimulus/dist/stimulus'

/* global fetchAPI, Turbolinks, I18n, Routes */

export class SearchBarController extends Controller {
  static get targets () {
    return ['input', 'history', 'results']
  }

  static get values () {
    return { highlight: { type: Boolean, default: true } }
  }

  onFocus () {
    if (this.hasResults()) {
      this.showResults()
      this.hideHistory()
    } else {
      this.showHistory()
      this.hideResults()
    }
  }

  selectItem ({ params: { url } }) {
    Turbolinks.visit(url)
  }

  suggestionTemplate ({ data, descriptor, icon, url }) {
    return `
      <li class="list-group-item list-group-item-action p-2 border-0 text-start text-truncate" data-action="mousedown->search-bar#selectItem" data-search-bar-url-param="${url}" role="button">
        <i class="fa fa-${icon} text-secondary fa-fw me-2"></i>
        ${this.highlight(data[descriptor], this.inputTarget.value)}
      </li>
    `
  }

  notFoundTemplate () {
    return `
      <li class="list-group-item disabled p-2 border-0 text-start text-truncate">
        <i class="fa fa-exclamation-triangle text-secondary fa-fw me-2"></i>
        ${I18n.typeahead.notFound}
      </li>
    `
  }

  pendingTemplate () {
    return `
      <li class="list-group-item disabled p-2 border-0 text-start text-truncate">
        <i class="fa fa-spinner fa-spin text-secondary fa-fw me-2"></i>
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

  hasResults () {
    return this.resultsTarget.innerHTML !== ''
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

  isValid () {
    return this.inputTarget.value.length >= this.inputTarget.getAttribute('minlength')
  }

  async search (e) {
    if (this.isValid()) {
      if (e.key === 'Enter') {
        this.hideHistory()
        this.hideResults()
      } else {
        this.showResults()
        this.hideHistory()
        this.resultsTarget.innerHTML = this.pendingTemplate()
        const response = await fetchAPI(this.url)
        const results = await response.json()
        if (Object.keys(results).length === 0) {
          this.resultsTarget.innerHTML = this.notFoundTemplate()
        } else {
          this.resultsTarget.innerHTML = Object
            .values(results)
            .flat()
            .map(this.suggestionTemplate.bind(this))
            .join('')
        }
      }
    } else {
      this.clearResults()
      this.showHistory()
    }
  }

  get url () {
    return Routes.searchEn(this.inputTarget.value)
  }
}
