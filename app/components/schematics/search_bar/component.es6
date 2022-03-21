/* global Stimulus, fetchAPI, Turbolinks, I18n, Routes */

window.SearchBarController = class extends Stimulus.Controller {
  static get targets () {
    return ['input', 'history', 'results']
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
        ${I18n.typeahead.notFound}
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
