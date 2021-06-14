/* global Stimulus, fetchAPI, Turbolinks, ENTITY_ICONS, TYPEAHEAD_I18N_NOT_FOUND, TYPEAHEAD_I18N_PENDING */

window.SearchBarController = class extends Stimulus.Controller {
  static get targets () {
    return ['input', 'results']
  }

  connect () {
    this.inputTarget.addEventListener('search', this.onSearch.bind(this))
    this.inputTarget.addEventListener('blur', this.clearResults.bind(this))
  }

  disconnect () {
    this.inputTarget.removeEventListener('search', this.onSearch)
    this.inputTarget.removeEventListener('blur', this.clearResults)
  }

  onSearch () {
    this.clearResults()
  }

  findDescriptor (result) {
    if (typeof result === 'object' && result != null) {
      const key = Object.keys(result).find(_ => _ !== 'id') || 'id'
      return this.findDescriptor(result[key])
    }
    return result
  }

  formatResults (results) {
    return Object.entries(results).flatMap(([key, value]) => {
      return value.map(result => {
        return {
          url: '/' + [key, result.id].filter(Boolean).join('/'),
          icon: ENTITY_ICONS[key],
          descriptor: this.findDescriptor(result)
        }
      })
    })
  }

  goTo (event) {
    Turbolinks.visit(event.currentTarget.dataset.url)
  }

  suggestionTemplate ({ descriptor, icon, url }) {
    return `
      <li class="list-group-item p-2 border-0 text-left text-truncate" data-action="mousedown->searchBar#goTo" data-url="${url}" role="button">
        <i class="fa fa-${icon} text-dark fa-fw mr-2"></i>
        ${this.highlight(descriptor, this.inputTarget.value)}
      </li>
    `
  }

  notFoundTemplate () {
    return `
      <li class="list-group-item p-2 border-0 text-left text-truncate">
        <i class="fa fa-exclamation-triangle text-dark fa-fw mr-2"></i>
        ${TYPEAHEAD_I18N_NOT_FOUND}
      </li>
    `
  }

  pendingTemplate () {
    return `
      <li class="list-group-item p-2 border-0 text-left text-truncate">
        <i class="fa fa-spinner fa-spin text-dark fa-fw mr-2"></i>
        ${TYPEAHEAD_I18N_PENDING}
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

  getUrl () {
    return `/searches/${this.inputTarget.value}`
  }

  async search () {
    const value = this.inputTarget.value
    const minLength = parseInt(this.data.get('minLength') || 3)
    this.clearResults()
    if (value.length >= minLength) {
      this.resultsTarget.insertAdjacentHTML('afterbegin', this.pendingTemplate())
      const response = await fetchAPI(this.getUrl())
      const results = await response.json()
      this.clearResults()
      if (Object.keys(results).length === 0) {
        this.resultsTarget.insertAdjacentHTML('afterbegin', this.notFoundTemplate())
      } else {
        this.formatResults(results).forEach(result => {
          this.resultsTarget.insertAdjacentHTML('afterbegin', this.suggestionTemplate(result))
        })
      }
    }
  }
}
